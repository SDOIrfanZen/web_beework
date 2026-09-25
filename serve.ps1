Add-Type -AssemblyName System.Net.HttpListener 2>$null

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:9000/")
$listener.Start()
Write-Host "Serving http://localhost:9000/ from $PWD" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop.`n" -ForegroundColor DarkGray

# Map file extensions to MIME types
$mimeTypes = @{
    '.html' = 'text/html; charset=utf-8'
    '.json' = 'application/json; charset=utf-8'
    '.exe'  = 'application/octet-stream'
    '.png'  = 'image/png'
    '.ico'  = 'image/x-icon'
    '.css'  = 'text/css; charset=utf-8'
    '.js'   = 'application/javascript; charset=utf-8'
}

while ($listener.IsListening) {
    $context  = $listener.GetContext()
    $req      = $context.Request
    $res      = $context.Response
    $urlPath  = $req.Url.LocalPath.TrimStart('/')

    # Serve index.html for root requests
    if ($urlPath -eq '' -or $urlPath -eq '/') {
        $urlPath = 'index.html'
    }

    # Serve from public directory if it exists, otherwise root
    $publicDir = Join-Path $PWD 'public'
    $targetDir = if (Test-Path $publicDir) { $publicDir } else { $PWD }
    $filePath = Join-Path $targetDir $urlPath
    $timestamp = Get-Date -Format "HH:mm:ss"

    if (Test-Path $filePath -PathType Leaf) {
        $ext         = [System.IO.Path]::GetExtension($filePath).ToLower()
        $contentType = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { 'application/octet-stream' }

        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $res.ContentType      = $contentType
        $res.ContentLength64  = $bytes.Length
        $res.StatusCode       = 200
        $res.OutputStream.Write($bytes, 0, $bytes.Length)

        Write-Host "[$timestamp] 200  $($req.Url.LocalPath)" -ForegroundColor Green
    } else {
        $res.StatusCode = 404
        Write-Host "[$timestamp] 404  $($req.Url.LocalPath)" -ForegroundColor Red
    }

    $res.OutputStream.Close()
}