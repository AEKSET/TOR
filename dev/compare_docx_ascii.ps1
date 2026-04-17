Add-Type -AssemblyName System.IO.Compression.FileSystem
$export = Get-ChildItem -Path '.\Test Export\*.docx' | Select-Object -First 1
$template = Get-ChildItem -Path '.\templates\tor\*.docx' | Where-Object { $_.Name -like '05. Terms of Reference*' } | Select-Object -First 1
if (-not $export) { Write-Error 'Export file not found'; exit 1 }
if (-not $template) { Write-Error 'Template file not found'; exit 1 }
Write-Host "Export file: $($export.FullName)"
Write-Host "Template file: $($template.FullName)"
$ze = [System.IO.Compression.ZipFile]::OpenRead($export.FullName)
$zt = [System.IO.Compression.ZipFile]::OpenRead($template.FullName)
$entriesE = $ze.Entries | Sort-Object FullName
$entriesT = $zt.Entries | Sort-Object FullName
$onlyE = $entriesE.FullName | Where-Object { $_ -notin $entriesT.FullName }
$onlyT = $entriesT.FullName | Where-Object { $_ -notin $entriesE.FullName }
Write-Host 'Entries only in export:'
$onlyE
Write-Host 'Entries only in template:'
$onlyT
Write-Host '---'
$common = $entriesE | Where-Object { $entriesT.FullName -contains $_.FullName }
foreach ($e in $common) {
    $t = $entriesT | Where-Object { $_.FullName -eq $e.FullName }
    if ($e.Length -ne $t.Length) {
        Write-Host "$($e.FullName): export=$($e.Length), template=$($t.Length)"
    }
}
$ze.Dispose()
$zt.Dispose()
