import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/app_button.dart';
import '../messaging/chat_screen.dart';

/// Athlete Detail Screen - Full profile view
class AthleteDetailScreen extends StatefulWidget {
  final String athleteId;

  const AthleteDetailScreen({
    super.key,
    required this.athleteId,
  });

  @override
  State<AthleteDetailScreen> createState() => _AthleteDetailScreenState();
}

class _AthleteDetailScreenState extends State<AthleteDetailScreen> {
  bool _isShortlisted = false;

  // Mock data - replace with API call
  final Map<String, dynamic> _athlete = {
    'id': '1',
    'name': 'Arjun Patel',
    'age': 18,
    'gender': 'Male',
    'sport': 'Cricket',
    'position': 'Batsman',
    'city': 'Mumbai',
    'state': 'Maharashtra',
    'performanceScore': 92,
    'isVerified': true,
    'phone': '+91 98765 43210',
    'email': 'arjun.patel@email.com',
    'about': 'Passionate cricketer with 5 years of experience. Represented Maharashtra in U-19 tournaments. Looking for opportunities to grow and learn from the best coaches.',
    'stats': {
      'Batting Avg': '45.2',
      'Strike Rate': '138.5',
      'Highest Score': '156',
      'Matches': '48',
    },
    'achievements': [
      {'title': 'U-19 State Championship', 'year': '2023'},
      {'title': 'Best Batsman Award', 'year': '2023'},
      {'title': 'District Level Selection', 'year': '2022'},
    ],
    'testResults': [
      {'name': '40m Sprint', 'score': 88, 'date': '2024-01-15'},
      {'name': 'Vertical Jump', 'score': 92, 'date': '2024-01-15'},
      {'name': 'Agility T-Test', 'score': 85, 'date': '2024-01-10'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _getSportColor(_athlete['sport']),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isShortlisted ? Icons.bookmark : Icons.bookmark_border,
                    color: _isShortlisted ? AppTheme.primaryOrange : AppTheme.textPrimary,
                  ),
                ),
                onPressed: () {
                  setState(() => _isShortlisted = !_isShortlisted);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isShortlisted ? 'Added to shortlist' : 'Removed from shortlist',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: AppTheme.textPrimary),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getSportColor(_athlete['sport']),
                      _getSportColor(_athlete['sport']).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getSportIcon(_athlete['sport']),
                        size: 150,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppTheme.primaryOrange,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_athlete['performanceScore']}',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_athlete['isVerified'])
                      Positioned(
                        top: 100,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                color: AppTheme.successColor,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Basic Info
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _athlete['name'],
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_athlete['sport']} • ${_athlete['position']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: _getSportColor(_athlete['sport']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Info Chips
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(Icons.cake, '${_athlete['age']} years'),
                      _buildInfoChip(Icons.person, _athlete['gender']),
                      _buildInfoChip(
                        Icons.location_on,
                        '${_athlete['city']}, ${_athlete['state']}',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stats
                  _buildSectionTitle('Performance Stats'),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                    children: (_athlete['stats'] as Map<String, dynamic>)
                        .entries
                        .map((entry) => _buildStatCard(entry.key, entry.value))
                        .toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // About
                  _buildSectionTitle('About'),
                  const SizedBox(height: 12),
                  Text(
                    _athlete['about'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Test Results
                  _buildSectionTitle('Test Results'),
                  const SizedBox(height: 12),
                  ...(_athlete['testResults'] as List).map((test) => 
                    _buildTestResultCard(test)
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Achievements
                  _buildSectionTitle('Achievements'),
                  const SizedBox(height: 12),
                  ...(_athlete['achievements'] as List).map((achievement) => 
                    _buildAchievementCard(achievement)
                  ),
                  
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Action Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppSecondaryButton(
                text: 'Schedule Trial',
                icon: Icons.calendar_today,
                borderColor: AppTheme.primaryOrange,
                textColor: AppTheme.primaryOrange,
                onPressed: () {
                  // Schedule trial
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppPrimaryButton(
                text: 'Message',
                icon: Icons.message,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        recipientId: _athlete['id'],
                        recipientName: _athlete['name'],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultCard(Map<String, dynamic> test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getScoreColor(test['score']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${test['score']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(test['score']),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  test['date'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_circle_outline,
            color: AppTheme.primaryOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.emoji_events,
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement['year'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return AppTheme.successColor;
    if (score >= 75) return AppTheme.primaryOrange;
    return AppTheme.errorColor;
  }

  Color _getSportColor(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return const Color(0xFF4CAF50);
      case 'football':
        return const Color(0xFF2196F3);
      case 'athletics':
        return const Color(0xFFFF9800);
      case 'badminton':
        return const Color(0xFF9C27B0);
      case 'hockey':
        return const Color(0xFF00BCD4);
      default:
        return AppTheme.primaryOrange;
    }
  }

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket;
      case 'football':
        return Icons.sports_soccer;
      case 'athletics':
        return Icons.directions_run;
      case 'badminton':
        return Icons.sports_tennis;
      case 'hockey':
        return Icons.sports_hockey;
      default:
        return Icons.sports;
    }
  }
}
