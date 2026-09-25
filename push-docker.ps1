param (
    [string]$Tag = "1.0.0"
)

$ErrorActionPreference = "Stop"

$repo = "zencomputersystems/beework"
$fullTag = "$repo`:$Tag"
$latestTag = "$repo`:latest"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Building & Pushing Docker Image" -ForegroundColor Cyan
Write-Host " Repository: $repo" -ForegroundColor Yellow
Write-Host " Tag:        $Tag and latest" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Build image with specific version and latest tag
Write-Host "`n[1/3] Building image..." -ForegroundColor Green
docker build -t $fullTag -t $latestTag .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker build failed."
    exit 1
}

# 2. Push specific version tag
Write-Host "`n[2/3] Pushing $fullTag..." -ForegroundColor Green
docker push $fullTag

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker push for $fullTag failed. Make sure you are logged in via 'docker login'."
    exit 1
}

# 3. Push latest tag
Write-Host "`n[3/3] Pushing $latestTag..." -ForegroundColor Green
docker push $latestTag

if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker push for $latestTag failed."
    exit 1
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host " Successfully pushed to Docker Hub!" -ForegroundColor Green
Write-Host " View your images at: https://hub.docker.com/r/$repo/tags" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan