$ErrorActionPreference = 'Stop'
$tr  = 'c:\Users\LAPTOP-MP2SMSG8\AppData\Roaming\Code\User\workspaceStorage\ff237b43ffdb11671c17d7d402229c18\GitHub.copilot-chat\transcripts\48e0f5a5-cdad-4783-8882-406bd8504354.jsonl'
$rep = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test\_recovered_slide2.txt'

$needle = 'What the timesheet' + ' is for'
$lines  = Get-Content -LiteralPath $tr -Encoding UTF8
$hits   = New-Object System.Collections.Generic.List[string]

function Walk($o, [System.Collections.Generic.List[string]]$acc) {
  if ($null -eq $o) { return }
  if ($o -is [string]) { $acc.Add($o); return }
  if ($o -is [System.Management.Automation.PSCustomObject]) {
    foreach ($p in $o.PSObject.Properties) { Walk $p.Value $acc }
    return
  }
  if ($o -is [System.Collections.IEnumerable]) {
    foreach ($i in $o) { Walk $i $acc }
    return
  }
}

$idx = 0
foreach ($ln in $lines) {
  $idx++
  if ($ln.IndexOf($needle) -lt 0) { continue }
  try { $obj = $ln | ConvertFrom-Json } catch { continue }
  $acc = New-Object System.Collections.Generic.List[string]
  Walk $obj $acc
  foreach ($s in $acc) {
    if ($s.IndexOf($needle) -ge 0) {
      $hits.Add("##### transcript line $idx")
      $hits.Add($s)
      $hits.Add("")
    }
  }
}

Write-Output ("lines scanned: {0}" -f $lines.Count)
Write-Output ("matches: {0}" -f $hits.Count)
$hits -join "`n" | Set-Content -LiteralPath $rep -Encoding UTF8
Write-Output ("written: {0} bytes to {1}" -f (Get-Item $rep).Length, $rep)
