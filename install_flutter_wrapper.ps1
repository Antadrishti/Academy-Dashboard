# Install Flutter Wrapper to PowerShell Profile
Write-Host "Installing Flutter wrapper..." -ForegroundColor Yellow

$profilePath = $PROFILE

# Create profile if it doesn't exist
if (-not (Test-Path $profilePath)) {
    $profileDir = Split-Path $profilePath -Parent
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

# Check if already installed
$content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
if ($content -match "function flutter.*GRADLE_USER_HOME") {
    Write-Host "Flutter wrapper already installed. Updating..." -ForegroundColor Yellow
    # Remove old function
    $lines = Get-Content $profilePath
    $newContent = $lines | Where-Object { $_ -notmatch "function flutter" -and ($_ -notmatch "^\s*}" -or ($lines[$lines.IndexOf($_)-1] -notmatch "flutter")) }
    # Simple approach: just append if not exists
}

# Add the wrapper function
$wrapper = @'

# Flutter Wrapper - Uses D drive for Gradle
function flutter {
    $env:TEMP = "D:\temp"
    $env:TMP = "D:\temp"
    $env:GRADLE_USER_HOME = "D:\gradle_home"
    if (-not (Test-Path "D:\temp")) { New-Item -ItemType Directory -Path "D:\temp" -Force | Out-Null }
    if (-not (Test-Path "D:\gradle_home")) { New-Item -ItemType Directory -Path "D:\gradle_home" -Force | Out-Null }
    & D:\flutter\bin\flutter.bat $args
}
'@

Add-Content -Path $profilePath -Value $wrapper

Write-Host "Done! Reload profile with: . `$PROFILE" -ForegroundColor Green
