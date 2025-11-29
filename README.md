# SAI Talent Platform - Flutter Application

A comprehensive talent discovery and management platform for athletes and academies.

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── models/          # Data models (User, Athlete, Academy, Message, etc.)
│   ├── services/        # API services (Auth, Academy, Messaging, etc.)
│   └── app_state.dart   # Global app state management
├── features/
│   ├── auth/           # Authentication screens (Welcome, Login, Register)
│   ├── academy/        # Academy-specific features
│   │   ├── dashboard/  # Dashboard and athlete management
│   │   ├── discovery/  # Athlete browsing and discovery
│   │   └── messaging/  # Communication features
│   └── ...            # Other features (athlete, tests, etc.)
└── ui/
    ├── theme/          # App theme and colors
    └── widgets/        # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 📱 Features

### Academy Features
- **Dashboard**: Overview of academy statistics and quick actions
- **Talent Discovery**: Browse and filter athletes with advanced search
- **Athlete Management**: Track shortlisted, selected, and rejected athletes
- **Messaging**: Direct communication with athletes
- **Analytics**: Performance insights and reports

### Authentication
- Role-based registration (Athlete/Academy)
- Phone-based authentication with OTP
- Secure JWT token management

## 🎨 Design System

- **Primary Color**: Orange (#f28d25)
- **Secondary Color**: Purple (#322259)
- **Theme**: Material 3 Design
- **State Management**: Provider

## 🔧 Configuration

Update the API base URL in `lib/core/services/api_service.dart`:
```dart
static const String baseUrl = 'http://your-backend-url/api';
```

## 📦 Dependencies

Key packages:
- `provider` - State management
- `http` - API calls
- `shared_preferences` - Local storage
- `sqflite` - Local database
- `image_picker` - Image selection
- `video_player` - Video playback
- `fl_chart` - Charts and graphs

See `pubspec.yaml` for complete list.

## 🏃 Development

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
flutter build apk  # Android
flutter build ios  # iOS
```

## 📝 License

[Your License Here]

