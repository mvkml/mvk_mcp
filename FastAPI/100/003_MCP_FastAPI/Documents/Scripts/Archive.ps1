param (
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$DestinationPath,

    [Parameter(Mandatory = $true)]
    [string]$ExcludeFolder
)

# Check if source exists
if (-not (Test-Path -Path $SourcePath)) {
    Write-Error "Source path '$SourcePath' does not exist."
    exit
}

# Create destination folder if it doesn't exist
if (-not (Test-Path -Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

Write-Host "Copying files from '$SourcePath' to '$DestinationPath' excluding folder '$ExcludeFolder'..." -ForegroundColor Cyan

# Get all items excluding the specified folder
Get-ChildItem -Path $SourcePath -Recurse -Force | Where-Object {
    -not ($_.FullName -like "*\$ExcludeFolder*")
} | ForEach-Object {
    $target = $_.FullName.Replace($SourcePath, $DestinationPath)

    if ($_.PSIsContainer) {
        if (-not (Test-Path $target)) {
            New-Item -ItemType Directory -Path $target | Out-Null
        }
    } else {
        Copy-Item -Path $_.FullName -Destination $target -Force
    }
}

Write-Host "Copy completed successfully!" -ForegroundColor Green
