# Complete script to run Flutter app with all configurations

# Set D drive temp directories
$env:TEMP = "D:\temp"
$env:TMP = "D:\temp"
$env:GRADLE_USER_HOME = "D:\gradle_home"

# Set Android SDK paths
$env:ANDROID_HOME = "C:\Users\Asmit\AppData\Local\Android\sdk"
$env:ANDROID_SDK_ROOT = "C:\Users\Asmit\AppData\Local\Android\sdk"
$env:PATH = "C:\Users\Asmit\AppData\Local\Android\sdk\platform-tools;C:\Users\Asmit\AppData\Local\Android\sdk\tools;$env:PATH"

# Create D drive directories if needed
if (-not (Test-Path "D:\temp")) {
    New-Item -ItemType Directory -Path "D:\temp" -Force | Out-Null
}
if (-not (Test-Path "D:\gradle_home")) {
    New-Item -ItemType Directory -Path "D:\gradle_home" -Force | Out-Null
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SAI Talent Platform - Flutter App" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Flutter SDK: D:\flutter" -ForegroundColor White
Write-Host "  Temp Dir: D:\temp" -ForegroundColor White
Write-Host "  Gradle Home: D:\gradle_home" -ForegroundColor White
Write-Host "  Android SDK: C:\Users\Asmit\AppData\Local\Android\sdk" -ForegroundColor White
Write-Host ""

# Check emulator
Write-Host "Checking emulator..." -ForegroundColor Yellow
$adbPath = "$env:ANDROID_HOME\platform-tools\adb.exe"
if (Test-Path $adbPath) {
    $devices = & $adbPath devices
    if ($devices -match "emulator-5554") {
        Write-Host "  ✓ Emulator found: emulator-5554" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Emulator not found. Please start your emulator first." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Starting Flutter app..." -ForegroundColor Yellow
Write-Host ""

# Run Flutter app
D:\flutter\bin\flutter.bat run -d emulator-5554

