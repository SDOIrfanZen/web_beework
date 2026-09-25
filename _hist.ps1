$ErrorActionPreference = 'SilentlyContinue'
$t = 'c:\Users\LAPTOP-MP2SMSG8\AppData\Roaming\Code\User\workspaceStorage\ff237b43ffdb11671c17d7d402229c18\GitHub.copilot-chat\transcripts\48e0f5a5-cdad-4783-8882-406bd8504354.jsonl'

Write-Output "===== transcript: mentions of the newer slide 2 ====="
foreach ($p in @('timesheet is for','Scope','What the timesheet','One loop','Manual timesheets are guesswork')) {
  $hits = Select-String -Path $t -Pattern $p -Encoding UTF8
  Write-Output ("--- /{0}/  ({1} hits)" -f $p, ($hits | Measure-Object).Count)
  if ($hits) {
    foreach ($h in ($hits | Select-Object -First 3)) {
      $idx = $h.Line.IndexOf($p)
      $s = [Math]::Max(0, $idx - 300); $len = [Math]::Min(700, $h.Line.Length - $s)
      Write-Output ("    line {0}, near col {1}:" -f $h.LineNumber, $idx)
      Write-Output ("      ..." + $h.Line.Substring($s, $len).Replace('\n',' ') + "...")
    }
  }
}

Write-Output ""
Write-Output "===== DOCKER ====="
Write-Output "--- images ---"
docker images --format "{{.Repository}}:{{.Tag}}  {{.Size}}  {{.CreatedSince}}" 2>&1 | ForEach-Object { Write-Output ("  " + $_) }
Write-Output "--- containers (all) ---"
docker ps -a --format "{{.Names}}  {{.Image}}  {{.Status}}  {{.CreatedAt}}" 2>&1 | ForEach-Object { Write-Output ("  " + $_) }
