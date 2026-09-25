$ErrorActionPreference = 'SilentlyContinue'
$t = 'c:\Users\LAPTOP-MP2SMSG8\AppData\Roaming\Code\User\workspaceStorage\ff237b43ffdb11671c17d7d402229c18\GitHub.copilot-chat\transcripts\48e0f5a5-cdad-4783-8882-406bd8504354.jsonl'
$out = 'c:\Users\LAPTOP-MP2SMSG8\Desktop\ota_test'

Write-Output "===== every tool op touching deck/index.html ====="
$lines = Get-Content $t -Encoding UTF8
$i = 0
foreach ($ln in $lines) {
  $i++
  if ($ln -notmatch 'deck\\\\index\.html|deck/index\.html') { continue }

  # find tool name
  $tool = '?'
  if ($ln -match '"name":"(create_file|replace_string_in_file|multi_replace_string_in_file|read_file|run_in_terminal)"') { $tool = $matches[1] }

  $ts = ''
  if ($ln -match '"timestamp":"([^"]+)"') { $ts = $matches[1] }

  # size of the arguments payload
  $sz = $ln.Length
  Write-Output ("  L{0,5}  {1,-28} {2,-24} payload={3}" -f $i, $tool, $ts, $sz)
}

Write-Output ""
Write-Output "===== looking for a FULL-FILE write (create_file) of deck ====="
$i = 0
foreach ($ln in $lines) {
  $i++
  if ($ln -match '"name":"create_file"' -and $ln -match 'deck') {
    Write-Output ("  L{0}  payload={1} chars" -f $i, $ln.Length)
    # try to extract the content length
    if ($ln -match '"filePath":"([^"]*deck[^"]*)"') { Write-Output ("      filePath: {0}" -f $matches[1]) }
    if ($ln -match '"content":"(.*)","filePath"') { Write-Output ("      content: {0} chars" -f $matches[1].Length) }
  }
}
