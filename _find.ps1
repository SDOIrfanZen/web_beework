$ErrorActionPreference = 'SilentlyContinue'
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'

Write-Output "===== ALL html files > 30KB under Desktop (any folder) ====="
Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8\Desktop' -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Extension -eq '.html' -and $_.Length -gt 30000 } |
  Sort-Object LastWriteTime -Descending |
  ForEach-Object { Write-Output ("  {0,8}  {1}  {2}" -f $_.Length, $_.LastWriteTime, $_.FullName) }

Write-Output ""
Write-Output "===== OneDrive / other Desktop roots ====="
Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8' -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -match 'OneDrive' } |
  ForEach-Object { Write-Output ("  {0}" -f $_.FullName) }

Write-Output ""
Write-Output "===== 'What the timesheet is for' anywhere on C:\Users ====="
Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8' -Recurse -Include '*.html','*.jsonl','*.txt','*.json' -File -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '\\fvm\\' } |
  ForEach-Object {
    $n = (Select-String -Path $_.FullName -Pattern 'What the timesheet is for' -Encoding UTF8 -ErrorAction SilentlyContinue | Measure-Object).Count
    if ($n -gt 0) { Write-Output ("  hits={0,-4} {1,8}  {2}" -f $n, $_.Length, $_.FullName) }
  }
