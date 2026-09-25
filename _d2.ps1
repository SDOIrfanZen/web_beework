$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'
$local = "$out\public\deck\index.html"
$live  = "$out\_live_deck.html"

Write-Output "===== SLIDE TITLES: LOCAL vs LIVE ====="
$lr = Select-String -Path $local -Pattern '<!-- (\d+) Â· (.+?) -->|<!-- (\d+) · (.+?) -->'
$vr = Select-String -Path $live  -Pattern '<!-- (\d+) Â· (.+?) -->|<!-- (\d+) · (.+?) -->'
Write-Output ("{0,4} {1,-26} | {2,-26}" -f '#','LOCAL','LIVE')
for ($i = 0; $i -lt 14; $i++) {
  $l = if ($lr[$i]) { ($lr[$i].Line -replace '.*<!--\s*','' -replace '\s*-->.*','') } else { '(none)' }
  $v = if ($vr[$i]) { ($vr[$i].Line -replace '.*<!--\s*','' -replace '\s*-->.*','') } else { '(none)' }
  $mark = if ($l -ne $v) { '  <-- DIFFERS' } else { '' }
  Write-Output ("{0,4} {1,-26} | {2,-26}{3}" -f ($i+1), $l, $v, $mark)
}

Write-Output ""
Write-Output "===== LINE-BY-LINE DIFF (local vs live) ====="
$L = Get-Content $local
$V = Get-Content $live
Write-Output ("  local lines: {0}   live lines: {1}" -f $L.Count, $V.Count)
$max = [Math]::Max($L.Count, $V.Count)
$diffs = 0
for ($i = 0; $i -lt $max; $i++) {
  $a = if ($i -lt $L.Count) { $L[$i] } else { '<EOF>' }
  $b = if ($i -lt $V.Count) { $V[$i] } else { '<EOF>' }
  if ($a -ne $b) {
    $diffs++
    if ($diffs -le 40) {
      Write-Output ("  LINE {0}:" -f ($i+1))
      Write-Output ("    L: {0}" -f $a.Trim())
      Write-Output ("    V: {0}" -f $b.Trim())
    }
  }
}
Write-Output ("  TOTAL DIFFERING LINES: {0}" -f $diffs)
