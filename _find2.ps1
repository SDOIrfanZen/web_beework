$ErrorActionPreference = 'SilentlyContinue'
$rep = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test\_find_report.txt'
$sb = New-Object System.Text.StringBuilder

function Add($t) { [void]$sb.AppendLine($t) }

Add "===== html files > 30KB under Desktop ====="
Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8\Desktop' -Recurse -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Extension -eq '.html' -and $_.Length -gt 30000 } |
  Sort-Object LastWriteTime -Descending |
  ForEach-Object { Add ("  {0,8}  {1}  {2}" -f $_.Length, $_.LastWriteTime, $_.FullName) }

Add ""
Add "===== 'timesheet is for' hits under C:\Users\LAPTOP-MP2SMSG8 ====="
$files = Get-ChildItem -Path 'C:\Users\LAPTOP-MP2SMSG8' -Recurse -Include '*.html','*.txt','*.json' -File -ErrorAction SilentlyContinue
Add ("  scanned {0} files" -f $files.Count)
foreach ($f in $files) {
  $hits = Select-String -Path $f.FullName -Pattern 'timesheet is for' -SimpleMatch -Encoding UTF8 -ErrorAction SilentlyContinue
  if ($hits) { Add ("  hits={0,-4} {1,9}  {2}" -f $hits.Count, $f.Length, $f.FullName) }
}

$sb.ToString() | Set-Content $rep -Encoding UTF8
Write-Output "written to $rep"
