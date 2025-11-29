# Flutter Environment Setup Script
# This script sets up environment variables to use D: drive for Gradle
# Source this script in your PowerShell session: . .\setup_flutter_env.ps1

# Set D drive temp directories
$env:TEMP = "D:\temp"
$env:TMP = "D:\temp"
$env:GRADLE_USER_HOME = "D:\gradle_home"

# Create D drive directories if needed
if (-not (Test-Path "D:\temp")) {
    New-Item -ItemType Directory -Path "D:\temp" -Force | Out-Null
}
if (-not (Test-Path "D:\gradle_home")) {
    New-Item -ItemType Directory -Path "D:\gradle_home" -Force | Out-Null
}

# Create a wrapper function for flutter
function flutter {
    # Set environment variables before running flutter
    $env:TEMP = "D:\temp"
    $env:TMP = "D:\temp"
    $env:GRADLE_USER_HOME = "D:\gradle_home"
    
    # Call the actual flutter command with all arguments
    & D:\flutter\bin\flutter.bat $args
}

Write-Host "✓ Flutter environment configured!" -ForegroundColor Green
Write-Host "  TEMP: $env:TEMP" -ForegroundColor Cyan
Write-Host "  GRADLE_USER_HOME: $env:GRADLE_USER_HOME" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now use 'flutter run' directly!" -ForegroundColor Yellow


