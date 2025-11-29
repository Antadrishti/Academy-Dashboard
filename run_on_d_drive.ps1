# PowerShell script to run Flutter app using D drive only

# Set all temp directories to D drive
$env:TEMP = "D:\temp"
$env:TMP = "D:\temp"
$env:TMPDIR = "D:\temp"

# Set Gradle home to D drive
$env:GRADLE_USER_HOME = "D:\gradle_home"

# Set Android SDK (use existing location)
$env:ANDROID_HOME = "C:\Users\Asmit\AppData\Local\Android\sdk"
$env:ANDROID_SDK_ROOT = "C:\Users\Asmit\AppData\Local\Android\sdk"
$env:PATH = "C:\Users\Asmit\AppData\Local\Android\sdk\platform-tools;C:\Users\Asmit\AppData\Local\Android\sdk\tools;$env:PATH"

# Create D drive directories if they don't exist
if (-not (Test-Path "D:\temp")) {
    New-Item -ItemType Directory -Path "D:\temp" -Force | Out-Null
}
if (-not (Test-Path "D:\gradle_home")) {
    New-Item -ItemType Directory -Path "D:\gradle_home" -Force | Out-Null
}

Write-Host "Environment configured to use D drive:" -ForegroundColor Green
Write-Host "TEMP: $env:TEMP" -ForegroundColor Cyan
Write-Host "GRADLE_USER_HOME: $env:GRADLE_USER_HOME" -ForegroundColor Cyan
Write-Host ""

# Run Flutter app
Write-Host "Starting Flutter app on emulator..." -ForegroundColor Yellow
D:\flutter\bin\flutter.bat run -d emulator-5554

