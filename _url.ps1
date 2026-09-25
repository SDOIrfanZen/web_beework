$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'

function Grab([string]$url, [string]$file) {
  try {
    $r = [System.Net.WebRequest]::Create($url)
    $r.Timeout = 20000
    $resp = $r.GetResponse()
    $cc = $resp.Headers['Cache-Control']
    $exp = $resp.Headers['Expires']
    $age = $resp.Headers['Age']
    $etag = $resp.Headers['ETag']
    $lm = $resp.Headers['Last-Modified']
    $bytes = (New-Object System.IO.StreamReader($resp.GetResponseStream())).ReadToEnd()
    $resp.Close()
    [System.IO.File]::WriteAllText($file, $bytes)
    $len = (Get-Item $file).Length
    Write-Output ("  {0}" -f $url)
    Write-Output ("     len={0}  CacheControl='{1}'" -f $len, $cc)
    Write-Output ("     Expires='{0}'  Age='{1}'  ETag='{2}'  LastMod='{3}'" -f $exp, $age, $etag, $lm)
  } catch { Write-Output ("  {0}  -> ERROR {1}" -f $url, $_.Exception.Message) }
}

Write-Output "===== which URL serves what ====="
Grab 'https://work.beesuite.app/deck/'            "$out\_v_dir.html"
Grab 'https://work.beesuite.app/deck/index.html'  "$out\_v_idx.html"

Write-Output ""
Write-Output "===== are those two identical? ====="
$h1 = (Get-FileHash "$out\_v_dir.html" -Algorithm MD5).Hash
$h2 = (Get-FileHash "$out\_v_idx.html" -Algorithm MD5).Hash
Write-Output ("  /deck/       md5={0}" -f $h1)
Write-Output ("  /deck/index  md5={0}" -f $h2)
Write-Output ("  SAME: {0}" -f ($h1 -eq $h2))

Write-Output ""
Write-Output "===== slide 2 title on each ====="
foreach ($f in @("$out\_v_dir.html","$out\_v_idx.html","$out\public\deck\index.html")) {
  $t = (Select-String -Path $f -Pattern 's-title">(.+?)</h2>' | Select-Object -Skip 1 -First 1)
  $k = (Select-String -Path $f -Pattern 's-kicker"><span class="dot"></span>(.+?)</p>' | Select-Object -Skip 1 -First 1)
  Write-Output ("  {0,-40} kicker={1}  title={2}" -f (Split-Path $f -Leaf), $k.Matches.Groups[1].Value, $t.Matches.Groups[1].Value)
}

Write-Output ""
Write-Output "===== does 'Scope' exist anywhere? ====="
foreach ($f in @("$out\_v_dir.html","$out\public\deck\index.html")) {
  Write-Output ("  {0}: {1} hits" -f (Split-Path $f -Leaf), (Select-String -Path $f -Pattern 'Scope' | Measure-Object).Count)
}
