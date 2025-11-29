# PowerShell Profile for Flutter Project
# This file should be copied to your PowerShell profile location
# To find your profile: $PROFILE
# To add to profile: Copy-Item .ps1_profile.ps1 $PROFILE -Force

# Check if we're in a Flutter project directory
$flutterProjectPath = "D:\Asmit\SIH p2"
if ($PWD.Path -eq $flutterProjectPath -or $PWD.Path.StartsWith($flutterProjectPath)) {
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
    
    # Override flutter command with wrapper function
    function flutter {
        # Ensure environment variables are set
        $env:TEMP = "D:\temp"
        $env:TMP = "D:\temp"
        $env:GRADLE_USER_HOME = "D:\gradle_home"
        
        # Call the actual flutter command
        & D:\flutter\bin\flutter.bat $args
    }
}

