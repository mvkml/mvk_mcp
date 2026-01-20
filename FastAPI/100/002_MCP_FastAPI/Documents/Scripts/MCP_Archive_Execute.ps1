# Define paths
[int]$myNumber = 4
$myNumber = $myNumber + 1
$index_value = "{0:D3}" -f $myNumber

$SourceFolderPath = "C:\v\v\learn\lv_python\ai\MCP"
$DestinationFolderPath = "C:\v\v\learn\lv_python\git\MCP_VishAgent"

#C:\v\v\learn\lv_python\git\mvk_mcp\FastAPI\100\001_MCP_FastAPI
$Destination_Final = "C:\v\v\learn\lv_python\git\mvk_mcp\FastAPI\100\$($index_value)_MCP_FastAPI"
$ReadMePath = "Documents\PostgreSQL"


#-----------------------------app ------------------------------
$SourcePath = "$SourceFolderPath\app"
$DestinationPath = "$DestinationFolderPath\app"
$SkipPath = "venv"

[bool]$isDocker = $true


# Get current script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Path to Archive.ps1
$ArchiveScript = Join-Path $ScriptDir "Archive.ps1"

Write-Host "🧩 Executing Archive Script..." -ForegroundColor Cyan
Write-Host "Script: $ArchiveScript" -ForegroundColor DarkGray

# Execute Archive.ps1
& powershell.exe -ExecutionPolicy Bypass -File $ArchiveScript `
    -SourcePath $SourcePath `
    -DestinationPath $DestinationPath `
    -ExcludeFolder $SkipPath

Write-Host "🏁 Archive process finished!" -ForegroundColor Yellow

#-----------------------------DOCUMENTS ------------------------------

 
$DestinationPath = "$DestinationFolderPath\Documents\*"
$SkipPath = "venv"

Remove-Item -Path $DestinationPath -Recurse -Force
Write-Host $DestinationPath -ForegroundColor Yellow
Write-Host "🏁 Archive process finished!" -ForegroundColor Yellow


$SourcePath = "$SourceFolderPath\Documents"
$DestinationPath = "$DestinationFolderPath\Documents"


# Execute Archive.ps1
& powershell.exe -ExecutionPolicy Bypass -File $ArchiveScript `
    -SourcePath $SourcePath `
    -DestinationPath $DestinationPath `
    -ExcludeFolder $SkipPath

Write-Host "🏁 Archive process finished!" -ForegroundColor Yellow



#-----------------------------Docker ------------------------------

if($isDocker)
{
$SourcePath = "$SourceFolderPath\Dockerfile"
$DestinationPath = "$DestinationFolderPath\Dockerfile"
Copy-Item -Path $SourcePath -Destination $DestinationPath -Force -Verbose
}
else{
Write-Host "No docker file process"
}



#-----------------------------Readme ------------------------------

$SourcePath = "$SourceFolderPath\app\README.md"
$DestinationPath = "$DestinationFolderPath\"
Copy-Item -Path $SourcePath -Destination $DestinationPath -Force


$SourcePath = "$SourceFolderPath\$ReadMePath"
$DestinationPath = "$DestinationFolderPath\"


# Execute Archive.ps1
& powershell.exe -ExecutionPolicy Bypass -File $ArchiveScript `
    -SourcePath $SourcePath `
    -DestinationPath $DestinationPath `
    -ExcludeFolder $SkipPath

Write-Host "🏁 Archive process finished!" -ForegroundColor Yellow


#-----------------------------Document ------------------------------


$SourcePath = "C:\v\v\learn\lv_python\git\config"
$DestinationPath = "$DestinationFolderPath\app"


# Execute Archive.ps1
& powershell.exe -ExecutionPolicy Bypass -File $ArchiveScript `
    -SourcePath $SourcePath `
    -DestinationPath $DestinationPath `
    -ExcludeFolder $SkipPath

Write-Host "🏁 Archive process finished!" -ForegroundColor Yellow





$SourcePath = "$DestinationFolderPath"
$DestinationPath = "$Destination_Final"


# Execute Archive.ps1
& powershell.exe -ExecutionPolicy Bypass -File $ArchiveScript `
    -SourcePath $SourcePath `
    -DestinationPath $DestinationPath `
    -ExcludeFolder $SkipPath

Write-Host "🏁 Archive process finished!" -ForegroundColor Yellow


Invoke-Item $DestinationPath