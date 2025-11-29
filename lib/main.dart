import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_state.dart';
import 'core/providers/language_provider.dart';
import 'ui/theme/app_theme.dart';

// Auth Screens
import 'features/auth/welcome_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/otp_verification_screen.dart';
import 'features/auth/academy_onboarding_screen.dart';
import 'features/auth/academy_register_screen.dart';

// Academy Screens
import 'features/academy/dashboard/dashboard_screen.dart';
import 'features/academy/discovery/athlete_detail_screen.dart';
import 'features/academy/messaging/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LanguageProvider? _languageProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final provider = LanguageProvider();
    try {
      await provider.initialize();
    } catch (e) {
      debugPrint('Language initialization error: $e');
    }
    if (mounted) {
      setState(() {
        _languageProvider = provider;
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _languageProvider == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider<LanguageProvider>.value(value: _languageProvider!),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, _) {
          return MaterialApp(
            title: 'SportsAadhaar',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('ta'),
              Locale('te'),
              Locale('mr'),
              Locale('bn'),
              Locale('gu'),
              Locale('kn'),
            ],
            locale: Locale(langProvider.currentLanguage.code),
            
            initialRoute: '/welcome',
            
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                case '/welcome':
                  return MaterialPageRoute(
                    builder: (_) => const WelcomeScreen(),
                    settings: settings,
                  );
                  
                case '/login':
                  return MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                    settings: settings,
                  );
                  
                case '/otp':
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => OTPVerificationScreen(
                      phoneNumber: args?['phone'] ?? '',
                    ),
                    settings: settings,
                  );
                  
                case '/academy-onboarding':
                  return MaterialPageRoute(
                    builder: (_) => const AcademyOnboardingScreen(),
                    settings: settings,
                  );
                  
                case '/academy-register':
                  return MaterialPageRoute(
                    builder: (_) => const AcademyRegisterScreen(),
                    settings: settings,
                  );
                  
                case '/dashboard':
                case '/academy-dashboard':
                  return MaterialPageRoute(
                    builder: (_) => const AcademyDashboardScreen(),
                    settings: settings,
                  );
                  
                case '/athlete-detail':
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => AthleteDetailScreen(
                      athleteId: args?['athleteId'] ?? '',
                    ),
                    settings: settings,
                  );
                  
                case '/chat':
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      recipientId: args?['recipientId'] ?? '',
                      recipientName: args?['recipientName'] ?? '',
                    ),
                    settings: settings,
                  );
                  
                default:
                  return MaterialPageRoute(
                    builder: (_) => const WelcomeScreen(),
                  );
              }
            },
            
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => const WelcomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
