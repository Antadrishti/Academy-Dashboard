import 'package:flutter/material.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/sports_logo.dart';
import '../../ui/widgets/app_button.dart';
import '../../ui/widgets/language_selector.dart';
import 'login_screen.dart';
import 'academy_onboarding_screen.dart';

/// SportsAadhaar Landing Screen - Academy Version
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Language Selector at top right
              Align(
                alignment: Alignment.centerRight,
                child: _buildLanguageSelector(context),
              ),
              
              const Spacer(flex: 2),
              
              // Logo
              const SportsLogo(
                size: 180,
                showText: false,
              ),
              
              const SizedBox(height: 32),
              
              // App Name
              const Text(
                'SportsAadhaar',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tagline
              Text(
                'Discover Talent. Scout Athletes.\nGrow Your Academy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              
              const Spacer(flex: 3),
              
              // Get Started Button
              AppPrimaryButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AcademyOnboardingScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Login Button
              AppSecondaryButton(
                text: 'Login',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return GestureDetector(
      onTap: () => LanguageSelectorSheet.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primaryOrange.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate,
              size: 18,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(width: 8),
            Text(
              'Language',
              style: TextStyle(
                color: AppTheme.primaryOrange,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: AppTheme.primaryOrange,
            ),
          ],
        ),
      ),
    );
  }
}
