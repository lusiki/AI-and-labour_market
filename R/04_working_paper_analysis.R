# Working-paper revision: reproducible descriptive estimates and diagnostics.
# Run from the project root. The source corpus is never modified.
invisible(Sys.setlocale("LC_CTYPE", "English_United States.utf8"))
invisible(Sys.setlocale("LC_TIME", "C"))
options(warn=1, width=160, scipen=999)
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(stringi); library(lubridate)
  library(fixest); library(sandwich); library(lmtest); library(strucchange)
})
source("R/00_helpers.R")
out <- "output/working-paper/analysis"
dir.create(out,recursive=TRUE,showWarnings=FALSE)
put <- function(x,nm) write.csv(x,file.path(out,paste0(nm,".csv")),row.names=FALSE,fileEncoding="UTF-8")
ct <- function(m,term) {
  z <- if(inherits(m,"fixest")) coeftable(m) else coeftest(m,vcov.=vcovHAC(m))
  tibble(term=term,estimate=z[term,1],se=z[term,2],p=z[term,4],n=nobs(m))
}
cache <- file.path(out,"scored_compact.rds")
fingerprint <- c(corpus=unname(tools::md5sum(path_raw_corpus_extended)),config=unname(tools::md5sum("config.yml")))
if(file.exists(cache) && identical(readRDS(paste0(cache,".key")),fingerprint)) {
  d <- readRDS(cache); cat("Loaded matching compact score cache.\n")
} else {
  d <- readRDS(path_raw_corpus_extended)
  d <- d |> mutate(DATE=as.Date(DATE),ym=floor_date(DATE,"month"),yr=year(DATE),
      t=(year(ym)-2021)*12+month(ym)-1,post=as.integer(DATE>=as.Date("2022-12-01")),
      ramp=pmax(t-23,0), words=stri_count_regex(FULL_TEXT,"\\S+"),
      suspect=DATE<as.Date("2022-11-30") & stri_detect_regex(.text_lower,"chat.?gpt"))
  for(f in names(CONFIG$frames)) {
    d[[f]] <- stri_detect_regex(d$.text_lower,paste(CONFIG$frames[[f]]$keywords,collapse="|"))
    cat("Scored",f,"\n"); flush.console()
  }
  d <- bind_cols(d,classify_outlets(d$FROM,d$SOURCE_TYPE)) |>
    mutate(threat=JOB_LOSS|FEAR_RESISTANCE|INEQUALITY,
      opportunity=JOB_CREATION|PRODUCTIVITY|TRANSFORMATION,
      threat_nofear=JOB_LOSS|INEQUALITY) |>
    select(-any_of(c("FULL_TEXT",".text_lower","AUTO_SENTIMENT","REACH","year","month","year_month")))
  saveRDS(d,cache); saveRDS(fingerprint,paste0(cache,".key"))
}
stopifnot(!anyNA(d$threat), !anyNA(d$SKILLS), !anyDuplicated(d[c("TITLE","DATE","FROM")]))
frames <- names(CONFIG$frames)
indicators <- c("threat","opportunity",frames)
monthly <- function(x) x |> group_by(ym,t,post,ramp) |>
  summarise(n=n(),skills_n=sum(SKILLS),sources=n_distinct(FROM),
    across(all_of(c(indicators,"threat_nofear")),~100*mean(.x)),.groups="drop") |> arrange(ym)
m <- monthly(d)
put(m,"monthly_all")
put(d |> count(SOURCE_TYPE,ym,name="n"),"platform_monthly")
put(monthly(filter(d,SOURCE_TYPE=="web")),"monthly_web")
put(d |> group_by(SOURCE_TYPE) |> summarise(pre=sum(post==0),post=sum(post==1),total=n(),
  share=100*n()/nrow(d),first=format(min(DATE),"%b %Y"),.groups="drop") |> arrange(desc(total)),"platforms")
put(d |> filter(SOURCE_TYPE=="forum") |> count(FROM,sort=TRUE),"forums")
put(d |> filter(!is.na(outlet)) |> group_by(outlet,outlet_type) |> summarise(pre=sum(post==0),post=sum(post==1),total=n(),
  months=n_distinct(ym),share=100*n()/nrow(d),.groups="drop"),"outlets")
put(bind_rows(lapply(CONFIG$paper1_outlets$outlets,function(o) tibble(outlet=o$name,domain=o$domains,type=o$type))),"domains")
put(d |> mutate(type=coalesce(outlet_type,ifelse(SOURCE_TYPE=="web","Other web","Non-web"))) |>
  group_by(type,post) |> summarise(n=n(),threat=100*mean(threat),opportunity=100*mean(opportunity),skills=100*mean(SKILLS),.groups="drop"),"types")
put(m |> group_by(post) |> summarise(months=n(),items=sum(n),monthly_n=mean(n),across(all_of(indicators),mean),skills_n=mean(skills_n),.groups="drop"),"period_monthly")
put(d |> group_by(yr) |> summarise(n=n(),sources=n_distinct(FROM),web=100*mean(SOURCE_TYPE=="web"),
  threat=100*mean(threat),fear=100*mean(FEAR_RESISTANCE),skills=100*mean(SKILLS),opportunity=100*mean(opportunity),.groups="drop"),"yearly")
put(bind_rows(lapply(c("all","web"),function(s) {
 mm <- if(s=="all") m else monthly(filter(d,SOURCE_TYPE=="web"))
 fit <- lm(n~t+post+ramp,mm)
 bind_rows(lapply(c("t","post","ramp"),function(z) ct(fit,z))) |> mutate(sample=s,bg_p=bgtest(fit,order=3)$p.value)
})),"volume_its")
put(bind_rows(lapply(c("threat","opportunity","FEAR_RESISTANCE","SKILLS"),function(y) {
 fit <- lm(reformulate(c("t","post","ramp"),y),m)
 bind_rows(lapply(c("t","post","ramp"),function(z) ct(fit,z))) |> mutate(indicator=y)
})),"segmented_shares")
put(bind_rows(lapply(indicators,function(y) ct(lm(reformulate(c("t","post"),y),m),"post") |> mutate(indicator=y))),"common_trend")
put(bind_rows(lapply(indicators,function(y) ct(lm(reformulate("t",y),filter(m,post==1)),"t") |> mutate(indicator=y))),"post_slopes")
windows <- bind_rows(lapply(c(6,9,12,18,24,36),function(w) {
 mm <- m |> filter(ym>=as.Date("2022-12-01") %m-% months(w),ym<as.Date("2022-12-01") %m+% months(w))
 fit <- lm(threat~t+post,mm)
 z <- coeftest(fit,vcov.=NeweyWest(fit,lag=3,prewhite=FALSE,adjust=TRUE))
 ct(fit,"post") |> mutate(window=w,pre_n=sum(mm$post==0),post_n=sum(mm$post==1),nw_p=z["post",4])
})) |> mutate(holm_p=p.adjust(p,"holm"))
put(windows,"windows")
pm <- filter(m,post==0) |> mutate(placebo=as.integer(ym>=as.Date("2021-12-01")),pramp=pmax(t-11,0))
put(bind_rows(lapply(c("placebo","pramp"),function(z) ct(lm(n~t+placebo+pramp,pm),z))),"placebo")
bp <- breakpoints(n~t,data=m,h=.15); ci <- confint(bp)$confint
put(tibble(point=as.character(m$ym[bp$breakpoints]),lower=as.character(m$ym[ci[,1]]),upper=as.character(m$ym[ci[,3]])),"breakpoints")
named <- filter(d,!is.na(outlet))
op <- named |> group_by(outlet,outlet_type,ym,t,post,ramp) |>
  summarise(n=n(),risk_only=100*mean(threat & !SKILLS),both=100*mean(threat & SKILLS),
    skills_only=100*mean(!threat & SKILLS),neither=100*mean(!threat & !SKILLS),
    threat=100*mean(threat),skills=100*mean(SKILLS),opportunity=100*mean(opportunity),.groups="drop")
stopifnot(max(abs(op$risk_only+op$both-op$threat))<1e-10,
  max(abs(op$skills_only+op$both-op$skills))<1e-10,
  max(abs(op$risk_only+op$both+op$skills_only+op$neither-100))<1e-10,
  sum(m$skills_n)==sum(d$SKILLS))
balanced_names <- op |> count(outlet) |> filter(n==nrow(m)) |> pull(outlet)
balanced <- filter(op,outlet %in% balanced_names) |> group_by(ym,t,post,ramp) |>
  summarise(outlets=n(),across(c(threat,skills,opportunity,risk_only,both,skills_only,neither),mean),.groups="drop")
put(balanced,"monthly_balanced")
put(balanced |> group_by(post) |> summarise(across(c(threat,skills,opportunity,risk_only,both,skills_only,neither),mean),.groups="drop"),"balanced_period")
put(named |> mutate(balanced=outlet %in% balanced_names) |> group_by(outlet,balanced) |> summarise(n=n(),.groups="drop"),"balanced_names")
sens <- list("Full corpus"=d,"Web only"=filter(d,SOURCE_TYPE=="web"),"Named outlets"=named,
  "Excluding suspect dates"=filter(d,!suspect),"Excluding January 2023"=filter(d,ym!=as.Date("2023-01-01")))
put(bind_rows(lapply(names(sens),function(s) ct(lm(threat~t+post,monthly(sens[[s]])),"post") |> mutate(sample=s)),
  ct(lm(threat_nofear~t+post,m),"post") |> mutate(sample="Threat excluding fear"),
  ct(lm(threat~t+post,balanced),"post") |> mutate(sample="Balanced, equal outlet weights")),"sensitivity")
dd <- d |> filter(outlet_type %in% c("Tabloid","Quality")) |>
  mutate(y=as.integer(threat),tabloid=as.integer(outlet_type=="Tabloid"),post_tab=post*tabloid)
dop <- dd |> group_by(outlet,ym,post_tab) |> summarise(y=mean(y),.groups="drop")
put(bind_rows(ct(feols(y~post_tab+tabloid|ym,dd,cluster=c("outlet","ym")),"post_tab") |> mutate(model="Group and month effects"),
  ct(feols(y~post_tab|outlet+ym,dd,cluster=c("outlet","ym")),"post_tab") |> mutate(model="Outlet and month effects"),
  ct(feols(y~post_tab|outlet+ym,dop,cluster=c("outlet","ym")),"post_tab") |> mutate(model="Equal outlet-month weights")),"outlet_models")
put(bind_rows(lapply(unique(dd$outlet),function(o) ct(feols(y~post_tab|outlet+ym,filter(dd,outlet!=o),cluster=c("outlet","ym")),"post_tab") |> mutate(excluded=o))),"leave_one_out")
eng <- filter(d,SOURCE_TYPE=="web",!is.na(INTERACTIONS))
put(eng |> group_by(yr) |> summarise(n=n(),zero=sum(INTERACTIONS==0),zero_pct=100*mean(INTERACTIONS==0),positive=sum(INTERACTIONS>0),.groups="drop"),"engagement_year")
put(bind_rows(lapply(c("additive","source_month","positive","ppml"),function(kind) {
 fit <- switch(kind,additive=feols(log1p(INTERACTIONS)~threat+opportunity|FROM+ym,eng,cluster="FROM"),
  source_month=feols(log1p(INTERACTIONS)~threat+opportunity|FROM^ym,eng,cluster="FROM"),
  positive=feols(log(INTERACTIONS)~threat+opportunity|FROM+ym,filter(eng,INTERACTIONS>0),cluster="FROM"),
  ppml=fepois(INTERACTIONS~threat+opportunity|FROM^ym,eng,cluster="FROM"))
 bind_rows(ct(fit,"threatTRUE"),ct(fit,"opportunityTRUE")) |> mutate(model=kind)
})),"engagement")
cat("Estimating title-similarity diagnostics.\n"); flush.console()
tok <- d |> mutate(id=row_number()) |> filter(!is.na(TITLE)) |>
  transmute(id,DATE,FROM,tok=stri_extract_all_regex(stri_trans_tolower(TITLE),"\\p{L}{4,}")) |>
  unnest(tok) |> distinct(id,tok,.keep_all=TRUE)
ntok <- count(tok,id,name="n_tok") |> filter(n_tok>=3)
tok <- semi_join(tok,ntok,by="id")
keys <- tok |> add_count(tok,name="df") |> arrange(id,df,tok) |> group_by(id) |> slice_head(n=2) |> ungroup() |>
  mutate(lo=DATE-3,hi=DATE+3)
cand <- inner_join(select(keys,id,tok,FROM,lo,hi),select(keys,id2=id,tok,FROM2=FROM,DATE2=DATE),
  by=join_by(tok,between(y$DATE2,x$lo,x$hi))) |> filter(id<id2,FROM!=FROM2) |> distinct(id,id2)
inter <- cand |> inner_join(select(tok,id,tok),by="id",relationship="many-to-many") |>
  semi_join(select(tok,id2=id,tok),by=c("id2","tok")) |> count(id,id2,name="inter") |>
  left_join(ntok,by="id") |> left_join(rename(ntok,id2=id,n_tok2=n_tok),by="id2") |>
  mutate(jac=inter/(n_tok+n_tok2-inter)) |> filter(jac>=.7)
dup_ids <- unique(c(inter$id,inter$id2))
put(d |> mutate(id=row_number(),matched=id %in% dup_ids) |> filter(id %in% ntok$id) |> group_by(post) |>
  summarise(n=n(),matched_n=sum(matched),share=100*mean(matched),threat_match=100*mean(threat[matched]),threat_unmatch=100*mean(threat[!matched]),.groups="drop"),"duplicates")
norm <- function(x) stri_trim(stri_replace_all_regex(stri_trans_tolower(x),"[^\\p{L}\\p{N} ]+"," "))
fbw <- inner_join(filter(d,SOURCE_TYPE=="facebook") |> transmute(k=norm(TITLE),DF=DATE,id_f=row_number()),
  filter(d,SOURCE_TYPE=="web") |> transmute(k=norm(TITLE),DW=DATE),by="k",relationship="many-to-many") |>
  filter(abs(as.numeric(DF-DW))<=2,nchar(k)>25)
put(tibble(n=nrow(d),web_n=sum(d$SOURCE_TYPE=="web"),named_n=nrow(named),named_outlets=n_distinct(named$outlet),
  balanced_outlets=length(balanced_names),balanced_n=sum(named$outlet %in% balanced_names),
  suspect_n=sum(d$suspect),fb_n=sum(d$SOURCE_TYPE=="facebook"),fb_matched=n_distinct(fbw$id_f),
  start=as.character(min(d$DATE)),end=as.character(max(d$DATE)),months=nrow(m),
  did_n=nrow(dd),did_outlets=n_distinct(dd$outlet),did_tabloids=n_distinct(dd$outlet[dd$tabloid==1])),"summary")
put(d |> filter(suspect) |> select(DATE,FROM,TITLE,URL),"suspect_dates")
put(bind_rows(lapply(frames,function(f) tibble(indicator=f,description=CONFIG$frames[[f]]$description,keyword=CONFIG$frames[[f]]$keywords))),"dictionary")
put(bind_rows(lapply(c("ai_patterns","labour_patterns"),function(g) tibble(group=g,label=names(CONFIG$regex[[g]]),pattern=unlist(CONFIG$regex[[g]])))),"retrieval_regex")
put(bind_rows(lapply(c("ai_sql_terms","labour_sql_terms"),function(g) tibble(group=g,pattern=unlist(CONFIG$extraction[[g]])))),"retrieval_sql")
writeLines(capture.output(sessionInfo()),file.path(out,"session_info.txt"))
put(tibble(file=names(fingerprint),md5=unname(fingerprint)),"input_fingerprints")
cat("All working-paper estimates saved.\n")
