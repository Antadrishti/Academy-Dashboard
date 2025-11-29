@echo off
echo ========================================
echo SAI Talent Platform - Starting App
echo ========================================
echo.

REM Set D drive temp directories
set TEMP=D:\temp
set TMP=D:\temp
set GRADLE_USER_HOME=D:\gradle_home

REM Set Android SDK
set ANDROID_HOME=C:\Users\Asmit\AppData\Local\Android\sdk
set ANDROID_SDK_ROOT=C:\Users\Asmit\AppData\Local\Android\sdk
set PATH=%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\tools;%PATH%

echo Configuration:
echo   Flutter: D:\flutter
echo   Temp: D:\temp
echo   Emulator: emulator-5554
echo.

echo Starting Flutter app...
echo.

D:\flutter\bin\flutter.bat run -d emulator-5554

pause


