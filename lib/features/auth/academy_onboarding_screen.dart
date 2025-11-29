import 'package:flutter/material.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/sports_logo.dart';
import '../../ui/widgets/app_button.dart';
import '../../ui/widgets/feature_card.dart';
import 'academy_register_screen.dart';
import 'login_screen.dart';

/// Academy Onboarding Screen
/// Shows features and benefits for academies
class AcademyOnboardingScreen extends StatelessWidget {
  const AcademyOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              // Logo
              const SportsLogo(size: 100),
              
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Welcome to\nSportsAadhaar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Discover and nurture the next generation\nof sports champions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Feature Cards
              const FeatureCard(
                icon: Icons.search,
                title: 'Discover Athletes',
                description: 'Browse and find talented athletes from across India.',
              ),
              
              const SizedBox(height: 12),
              
              const FeatureCard(
                icon: Icons.swipe,
                title: 'Scout Mode',
                description: 'Swipe through athlete profiles for quick evaluation.',
                iconColor: AppTheme.primaryOrange,
              ),
              
              const SizedBox(height: 12),
              
              const FeatureCard(
                icon: Icons.verified_outlined,
                title: 'Verify Performance',
                description: 'Conduct and verify official SAI tests.',
                iconColor: AppTheme.secondaryPurple,
              ),
              
              const SizedBox(height: 12),
              
              const FeatureCard(
                icon: Icons.message_outlined,
                title: 'Connect Directly',
                description: 'Message athletes and schedule trials.',
                iconColor: AppTheme.successColor,
              ),
              
              const Spacer(),
              
              // Get Started Button
              AppPrimaryButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AcademyRegisterScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
