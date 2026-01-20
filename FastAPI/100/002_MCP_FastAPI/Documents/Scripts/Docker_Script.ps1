$Host.PrivateData.ConsolePaneForegroundColor = 'White'

# ==============================
# Configuration
# ==============================
$ImageName     = "mcp_api_state"
$ContainerName = "mcp_api_container"
$Dockerfile    = "C:\v\v\learn\lv_python\ai\VishAgent\Dockerfile"
$BuildContext  = "C:\v\v\learn\lv_python\ai\VishAgent"

Write-Host "===== Docker Rebuild Script Started =====" -ForegroundColor Cyan

# ==============================
# Stop container if running
# ==============================
$container = docker ps -a --filter "name=$ContainerName" --format "{{.ID}}"
if ($container) {
    Write-Host "Stopping container: $ContainerName"
    docker stop $ContainerName | Out-Null

    Write-Host "Removing container: $ContainerName"
    docker rm $ContainerName | Out-Null
} else {
    Write-Host "Container not found: $ContainerName"
}

# ==============================
# Remove image if exists
# ==============================
$image = docker images $ImageName --format "{{.ID}}"
if ($image) {
    Write-Host "Removing image: $ImageName"
    docker rmi -f $ImageName | Out-Null
} else {
    Write-Host "Image not found: $ImageName"
}

# ==============================
# Build image (no cache)
# ==============================
Write-Host "Building image: $ImageName (no cache)"
docker build --no-cache -t $ImageName -f $Dockerfile $BuildContext

Write-Host "===== Docker Rebuild Script Completed =====" -ForegroundColor Green
