$ErrorActionPreference = 'SilentlyContinue'
$t = 'c:\Users\LAPTOP-MP2SMSG8\AppData\Roaming\Code\User\workspaceStorage\ff237b43ffdb11671c17d7d402229c18\GitHub.copilot-chat\transcripts\48e0f5a5-cdad-4783-8882-406bd8504354.jsonl'
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'
$lines = Get-Content $t -Encoding UTF8

Write-Output "===== LAST successful slide-2 'Scope' edit payload ====="
$best = $null
foreach ($ln in $lines) {
  if ($ln -match 'What the timesheet is for' -and $ln -match 'newString') { $best = $ln }
}
if ($best) {
  # decode the JSON escapes roughly
  $s = $best -replace '\\r\\n', "`n" -replace '\\n', "`n" -replace '\\"', '"' -replace '\\\\', '\'
  $idx = $s.IndexOf('<!-- 02')
  if ($idx -lt 0) { $idx = $s.IndexOf('Scope') }
  $st = [Math]::Max(0, $idx - 200)
  $len = [Math]::Min(4200, $s.Length - $st)
  Write-Output $s.Substring($st, $len)
  $s | Set-Content "$out\_slide2_recovered.txt" -Encoding UTF8
  Write-Output ""
  Write-Output ("  (saved {0} chars to _slide2_recovered.txt)" -f $len)
}

Write-Output ""
Write-Output "===== user's original slide-2 request (23/9) ====="
foreach ($ln in $lines) {
  if ($ln -match 'revise this as the scope of beework') {
    $s = $ln -replace '\\r\\n', "`n" -replace '\\n', "`n" -replace '\\"', '"'
    $i = $s.IndexOf('revise this as the scope')
    Write-Output $s.Substring($i, [Math]::Min(900, $s.Length - $i))
  }
}
