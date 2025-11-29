# Flutter Setup Guide

## Prerequisites

1. **Install Flutter SDK**
   - Download from: https://docs.flutter.dev/get-started/install/windows
   - Extract to a location like `C:\src\flutter`
   - Add Flutter to PATH:
     - Search for "Environment Variables" in Windows
     - Edit System Environment Variables
     - Add `C:\src\flutter\bin` to PATH
   - Verify: Open new terminal and run `flutter --version`

2. **Install Android Studio** (for Android development)
   - Download from: https://developer.android.com/studio
   - Install Android SDK and Android Studio
   - Accept Android licenses: `flutter doctor --android-licenses`

3. **Install VS Code** (optional but recommended)
   - Install Flutter extension
   - Install Dart extension

## Setup Steps

1. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```
   Fix any issues shown.

2. **Initialize Flutter Project** (if not already done)
   ```bash
   flutter create .
   ```
   This will create Android/iOS folders.

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   ```bash
   flutter run
   ```
   
   Or use VS Code:
   - Press F5
   - Or click "Run" > "Start Debugging"

## Troubleshooting

- **Flutter not found**: Make sure Flutter is in PATH and restart terminal
- **No devices**: Connect an Android device or start an emulator
- **Build errors**: Run `flutter clean` then `flutter pub get`

## Quick Start (If Flutter is Installed)

```bash
# Install dependencies
flutter pub get

# Check for devices
flutter devices

# Run on connected device/emulator
flutter run

# Or run on Chrome (web)
flutter run -d chrome
```

