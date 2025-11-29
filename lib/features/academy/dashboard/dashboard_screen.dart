import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../core/app_state.dart';
import '../../../ui/widgets/language_selector.dart';
import 'athlete_management_screen.dart';
import '../discovery/scout_mode_screen.dart';
import '../discovery/athlete_browse_screen.dart';
import '../messaging/conversations_screen.dart';
import '../analytics/analytics_dashboard_screen.dart';

class AcademyDashboardScreen extends StatefulWidget {
  const AcademyDashboardScreen({super.key});

  @override
  State<AcademyDashboardScreen> createState() => _AcademyDashboardScreenState();
}

class _AcademyDashboardScreenState extends State<AcademyDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const ScoutModeScreen();
      case 1:
        return const AthleteBrowseScreen();
      case 2:
        return const ConversationsScreen();
      case 3:
        return const AnalyticsDashboardScreen();
      case 4:
        return _buildProfileTab();
      default:
        return const ScoutModeScreen();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryOrange,
        unselectedItemColor: AppTheme.textSecondary,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.swipe),
            activeIcon: Icon(Icons.swipe),
            label: 'Scout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Academy Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryOrange,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.school,
                size: 50,
                color: AppTheme.primaryOrange,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              user?.academyName ?? 'Your Academy',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 4),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: AppTheme.successColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Verified Academy',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Profile Options
            _buildProfileOption(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.people,
              title: 'Manage Athletes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AthleteManagementScreen(),
                  ),
                );
              },
            ),
            _buildProfileOption(
              icon: Icons.emoji_events,
              title: 'Achievements',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.translate,
              title: 'Language',
              onTap: () => LanguageSelectorSheet.show(context),
            ),
            _buildProfileOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Logout',
              isDestructive: true,
              onTap: () {
                appState.logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/welcome',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppTheme.errorColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
