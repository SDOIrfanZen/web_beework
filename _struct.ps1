$ErrorActionPreference = 'SilentlyContinue'
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'
$f = "$out\_v_dir.html"

Write-Output "===== ALL SLIDE KICKERS + TITLES (live) ====="
$c = Get-Content $f
for ($i = 0; $i -lt $c.Count; $i++) {
  if ($c[$i] -match 'id="s(\d+)"') {
    $n = $matches[1]
    $kick = ''; $title = ''
    for ($j = $i; $j -lt [Math]::Min($c.Count, $i + 14); $j++) {
      if (-not $kick  -and $c[$j] -match 's-kicker"><span class="dot"></span>(.*?)</p>') { $kick = $matches[1] }
      if (-not $title -and $c[$j] -match 's-title">(.*?)</h2>')                          { $title = $matches[1] }
      if (-not $title -and $c[$j] -match 'hero-title">(.*?)</h1>')                        { $title = $matches[1] }
    }
    Write-Output ("  s{0,-3} [{1}]  {2}" -f $n, $kick, $title)
  }
}

Write-Output ""
Write-Output "===== KEY MARKERS in live deck ====="
foreach ($p in @('face scanner','End session','open the app and click','Scope','timesheet is for','Manual timesheets','One loop','Update check','Auto-update','Standard installer','Windows 10','Runs in the tray','Windows desktop app','Activity','Reporting','Rollout','Supervisor','hrs','hours')) {
  $n = (Select-String -Path $f -Pattern $p | Measure-Object).Count
  Write-Output ("  {0,-26} {1}" -f $p, $n)
}

Write-Output ""
Write-Output "===== OTHER deck/index.html copies on disk ====="
Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8' -Recurse -Filter 'index.html' -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -match 'deck' -and $_.FullName -notmatch '\\fvm\\' } |
  ForEach-Object { Write-Output ("  {0,8}  {1}  {2}" -f $_.Length, $_.LastWriteTime, $_.FullName) }

Write-Output ""
Write-Output "===== ANY file containing 'timesheet is for' ====="
Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8\Desktop' -Recurse -Include '*.html' -File -ErrorAction SilentlyContinue |
  ForEach-Object {
    $n = (Select-String -Path $_.FullName -Pattern 'timesheet is for' -ErrorAction SilentlyContinue | Measure-Object).Count
    if ($n -gt 0) { Write-Output ("  {0,8}  {1}  hits={2}" -f $_.Length, $_.FullName, $n) }
  }
