// Headless browser check of the local self-contained HTML edition.
import {spawn} from 'node:child_process';
import {writeFile, mkdir} from 'node:fs/promises';
import path from 'node:path';
import {pathToFileURL} from 'node:url';
const root=process.cwd();
const qa=path.join(root,'output','working-paper','qa');
await mkdir(qa,{recursive:true});
const port=19329;
const browser=spawn('C:/Program Files/Google/Chrome/Application/chrome.exe',[
 '--headless','--disable-gpu','--no-first-run','--no-default-browser-check','--disable-background-networking',
 `--remote-debugging-port=${port}`,`--user-data-dir=${path.join(qa,'chrome-profile')}`,'about:blank'
],{windowsHide:true,stdio:'ignore'});
const delay=ms=>new Promise(r=>setTimeout(r,ms));
let ws;const pending=new Map();let id=0;
try {
 let pages;
 for(let i=0;i<60;i++){
  try {pages=await(await fetch(`http://127.0.0.1:${port}/json`)).json();break;}catch{await delay(250);}
 }
 if(!pages)throw Error('Headless browser did not start');
 ws=new WebSocket(pages.find(x=>x.type==='page').webSocketDebuggerUrl);
 await new Promise((r,j)=>{ws.onopen=r;ws.onerror=j;});
 ws.onmessage=ev=>{const msg=JSON.parse(ev.data);if(msg.id){const p=pending.get(msg.id);pending.delete(msg.id);msg.error?p.reject(msg.error):p.resolve(msg.result);}};
 ws.onclose=ev=>{for(const p of pending.values())p.reject(Error('Browser connection closed: '+ev.code));};
 const call=(method,params={})=>new Promise((resolve,reject)=>{const key=++id;pending.set(key,{resolve,reject});ws.send(JSON.stringify({id:key,method,params}));});
 await call('Page.enable');await call('Runtime.enable');
 await call('Emulation.setDeviceMetricsOverride',{width:1200,height:1000,deviceScaleFactor:1,mobile:false});
 await call('Page.navigate',{url:pathToFileURL(path.join(root,'output','working-paper','ChatGPT_Croatia_Working_Paper.html')).href});
 await delay(1500);
 const check=await call('Runtime.evaluate',{expression:`JSON.stringify({title:document.title,images:[...document.images].map(i=>({loaded:i.complete&&i.naturalWidth>0,width:i.width})),tables:document.querySelectorAll('table').length,math:document.querySelectorAll('math').length,overflow:document.documentElement.scrollWidth>window.innerWidth,refs:document.querySelectorAll('.csl-entry').length})`,returnByValue:true});
 const result=JSON.parse(check.result.value);
 await writeFile(path.join(qa,'html-validation.json'),JSON.stringify(result,null,2));
 if(result.overflow||result.images.some(i=>!i.loaded))throw Error('HTML overflow or broken image');
 for(const [name,expression] of [['front','window.scrollTo(0,0)'],['results',`document.querySelector('#results').scrollIntoView()`],['references',`document.querySelector('#references').scrollIntoView()`]]){
  await call('Runtime.evaluate',{expression});await delay(150);
  const shot=await call('Page.captureScreenshot',{format:'png'});
  await writeFile(path.join(qa,`html-${name}.png`),Buffer.from(shot.data,'base64'));
 }
 await call('Emulation.setDeviceMetricsOverride',{width:430,height:900,deviceScaleFactor:1,mobile:false});
 await call('Runtime.evaluate',{expression:'window.scrollTo(0,0)'});await delay(200);
 const mobile=await call('Runtime.evaluate',{expression:'document.documentElement.scrollWidth>window.innerWidth',returnByValue:true});
 result.mobile_overflow=mobile.result.value;
 const shot=await call('Page.captureScreenshot',{format:'png'});
 await writeFile(path.join(qa,'html-mobile.png'),Buffer.from(shot.data,'base64'));
 await writeFile(path.join(qa,'html-validation.json'),JSON.stringify(result,null,2));
 console.log(JSON.stringify(result));
 await call('Browser.close');
} finally {if(ws)ws.close();browser.kill();}
