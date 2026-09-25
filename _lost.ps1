$ErrorActionPreference = 'SilentlyContinue'
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'
$f = "$out\_v_dir.html"

Write-Output "===== slide 12 (updates) in live ====="
$c = Get-Content $f
for ($i = 0; $i -lt $c.Count; $i++) {
  if ($c[$i] -match 'id="s12"') {
    for ($j = $i; $j -lt [Math]::Min($c.Count, $i + 26); $j++) { Write-Output ("  {0,5}: {1}" -f ($j+1), $c[$j]) }
    break
  }
}

Write-Output ""
Write-Output "===== every 'End session' / 'session' button line in live ====="
Select-String -Path $f -Pattern 'End session|End Session|Stop Tracking' | ForEach-Object {
  Write-Output ("  {0,5}: {1}" -f $_.LineNumber, $_.Line.Trim())
}

Write-Output ""
Write-Output "===== RECYCLE BIN: html files ====="
$sh = New-Object -ComObject Shell.Application
$bin = $sh.Namespace(10)
foreach ($it in $bin.Items()) {
  $orig = $bin.GetDetailsOf($it, 1)
  if ($it.Name -match '\.html$' -or $orig -match 'deck|manual') {
    Write-Output ("  {0}  |  orig: {1}  |  deleted: {2}" -f $it.Name, $orig, $bin.GetDetailsOf($it,2))
  }
}

Write-Output ""
Write-Output "===== temp / backup html on disk (any) ====="
Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8' -Recurse -Include '*.html','*.html.bak','*deck*.html' -File -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '\\fvm\\|\\\.vscode\\|AppData\\Local\\Microsoft\\Edge|AppData\\Local\\Google' -and $_.Length -gt 40000 } |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 25 |
  ForEach-Object { Write-Output ("  {0,8}  {1}  {2}" -f $_.Length, $_.LastWriteTime, $_.FullName) }
