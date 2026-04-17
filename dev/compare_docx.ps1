$export = 'C:\Users\AEKKARAT\OneDrive - The Stock Exchange of Thailand\Claude\แบบฟอร์ม TOR งาน Turnkey\Test Export\โครงการพัฒนาระบบบริหารจัดการสัญญาและการจัดซื้อจัดจ้าง (Contract & Procurement Management System)_20260409_1356.docx'
$template = 'C:\Users\AEKKARAT\OneDrive - The Stock Exchange of Thailand\Claude\แบบฟอร์ม TOR งาน Turnkey\templates\tor\05. Terms of Reference (ToR) SET_PRO_05_v.2_20250509_แก้ไขแจ้ง Password.docx'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$ze = [System.IO.Compression.ZipFile]::OpenRead($export)
$zt = [System.IO.Compression.ZipFile]::OpenRead($template)
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
