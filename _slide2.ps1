$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'
$wc = New-Object System.Net.WebClient
$wc.DownloadString('https://work.beesuite.app/deck/') | Set-Content "$out\_live_deck.html" -Encoding UTF8

$local = "$out\public\deck\index.html"
$live  = "$out\_live_deck.html"

Write-Output "===== SIZES / TIMES ====="
Write-Output ("  local deck : {0,7} B   {1}" -f (Get-Item $local).Length, (Get-Item $local).LastWriteTime)
Write-Output ("  live  deck : {0,7} B" -f (Get-Item $live).Length)

Write-Output ""
Write-Output "===== SLIDE 1 & 2 : LOCAL ====="
$lc = Get-Content $local
$s = ($lc | Select-String -Pattern '<!-- 01' | Select-Object -First 1).LineNumber
for ($i = $s - 1; $i -lt [Math]::Min($lc.Count, $s + 55); $i++) { Write-Output ("  {0,5}: {1}" -f ($i+1), $lc[$i]) }

Write-Output ""
Write-Output "===== SLIDE 1 & 2 : LIVE ====="
$vc = Get-Content $live
$s2 = ($vc | Select-String -Pattern '<!-- 01' | Select-Object -First 1).LineNumber
if (-not $s2) { $s2 = ($vc | Select-String -Pattern 'id="s1"' | Select-Object -First 1).LineNumber }
for ($i = $s2 - 1; $i -lt [Math]::Min($vc.Count, $s2 + 55); $i++) { Write-Output ("  {0,5}: {1}" -f ($i+1), $vc[$i]) }
