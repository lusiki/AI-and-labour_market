# Export only the generated working-paper document using a private Word instance.
$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
$docPath = [IO.Path]::GetFullPath((Join-Path $taskRoot 'output/working-paper/ChatGPT_Croatia_Working_Paper.docx'))
$pdfPath = [IO.Path]::GetFullPath((Join-Path $taskRoot 'output/working-paper/ChatGPT_Croatia_Working_Paper.pdf'))
$wordApp = $null
$taskDocument = $null
try {
    $wordApp = New-Object -ComObject Word.Application
    $wordApp.Visible = $false
    $wordApp.DisplayAlerts = 0
    $wordApp.Options.SaveNormalPrompt = $false
    $wordApp.ScreenUpdating = $false
    Write-Output 'Opening generated Word manuscript'
    $taskDocument = $wordApp.Documents.Open($docPath, $false, $false)
    $taskDocument.Fields.Update() | Out-Null
    $taskDocument.Repaginate()
    $taskDocument.Save()
    Write-Output 'Exporting PDF'
    # 17 = wdExportFormatPDF; document remains an editable Word manuscript.
    $taskDocument.ExportAsFixedFormat($pdfPath,17,$false,0,0,1,1,0,$true,$false,1,$true,$true,$false)
    Write-Output ('Exported PDF; Word pages: ' + $taskDocument.ComputeStatistics(2))
} finally {
    if ($null -ne $taskDocument) { $taskDocument.Close(0) }
    if ($null -ne $wordApp) { $wordApp.Quit() }
    if ($null -ne $taskDocument) { [Runtime.InteropServices.Marshal]::ReleaseComObject($taskDocument) | Out-Null }
    if ($null -ne $wordApp) { [Runtime.InteropServices.Marshal]::ReleaseComObject($wordApp) | Out-Null }
}
