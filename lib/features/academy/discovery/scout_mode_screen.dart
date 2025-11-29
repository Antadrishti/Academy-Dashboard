import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';
import 'athlete_detail_screen.dart';
import 'filters_sheet.dart';

/// Scout Mode Screen - Tinder-like swipe interface for discovering athletes
/// This is used as a TAB in the dashboard, not a standalone screen
class ScoutModeScreen extends StatefulWidget {
  const ScoutModeScreen({super.key});

  @override
  State<ScoutModeScreen> createState() => _ScoutModeScreenState();
}

class _ScoutModeScreenState extends State<ScoutModeScreen>
    with TickerProviderStateMixin {
  List<AthleteCardData> _athletes = [];
  int _currentIndex = 0;
  Offset _cardOffset = Offset.zero;
  double _cardAngle = 0;

  late AnimationController _swipeAnimationController;
  late Animation<Offset> _swipeAnimation;
  late AnimationController _returnAnimationController;
  late Animation<Offset> _returnAnimation;

  @override
  void initState() {
    super.initState();
    _loadAthletes();
    
    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _returnAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _returnAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _returnAnimationController,
      curve: Curves.easeOut,
    ));
    
    _returnAnimationController.addListener(() {
      setState(() {
        _cardOffset = _returnAnimation.value;
        _cardAngle = _cardOffset.dx / 1000;
      });
    });
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    _returnAnimationController.dispose();
    super.dispose();
  }

  void _loadAthletes() {
    // Mock data - replace with API call
    _athletes = [
      AthleteCardData(
        id: '1',
        name: 'Arjun Patel',
        age: 18,
        sport: 'Cricket',
        position: 'Batsman',
        city: 'Mumbai',
        state: 'Maharashtra',
        performanceScore: 92,
        isVerified: true,
        imageUrl: null,
        stats: {'Batting Avg': '45.2', 'Strike Rate': '138.5'},
      ),
      AthleteCardData(
        id: '2',
        name: 'Priya Sharma',
        age: 17,
        sport: 'Athletics',
        position: '100m Sprint',
        city: 'Delhi',
        state: 'Delhi',
        performanceScore: 88,
        isVerified: true,
        imageUrl: null,
        stats: {'Best Time': '11.8s', 'National Rank': '#45'},
      ),
      AthleteCardData(
        id: '3',
        name: 'Rahul Kumar',
        age: 19,
        sport: 'Football',
        position: 'Striker',
        city: 'Kolkata',
        state: 'West Bengal',
        performanceScore: 85,
        isVerified: false,
        imageUrl: null,
        stats: {'Goals': '23', 'Assists': '12'},
      ),
      AthleteCardData(
        id: '4',
        name: 'Sneha Reddy',
        age: 16,
        sport: 'Badminton',
        position: 'Singles',
        city: 'Hyderabad',
        state: 'Telangana',
        performanceScore: 94,
        isVerified: true,
        imageUrl: null,
        stats: {'Win Rate': '78%', 'State Rank': '#3'},
      ),
      AthleteCardData(
        id: '5',
        name: 'Vikram Singh',
        age: 20,
        sport: 'Hockey',
        position: 'Midfielder',
        city: 'Chandigarh',
        state: 'Punjab',
        performanceScore: 87,
        isVerified: true,
        imageUrl: null,
        stats: {'Goals': '15', 'Matches': '45'},
      ),
    ];
  }

  void _onPanStart(DragStartDetails details) {
    // Drag started
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _cardOffset += details.delta;
      _cardAngle = _cardOffset.dx / 1000;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final speed = velocity.distance;
    
    if (_cardOffset.dx.abs() > 100 || speed > 800) {
      if (_cardOffset.dx > 0) {
        _swipeRight();
      } else {
        _swipeLeft();
      }
    } else if (_cardOffset.dy < -100) {
      _viewProfile();
    } else {
      _returnToCenter();
    }
  }

  void _swipeRight() {
    _animateSwipe(const Offset(500, 0));
    _onShortlist(_athletes[_currentIndex]);
  }

  void _swipeLeft() {
    _animateSwipe(const Offset(-500, 0));
    _onSkip(_athletes[_currentIndex]);
  }

  void _animateSwipe(Offset endOffset) {
    _swipeAnimation = Tween<Offset>(
      begin: _cardOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: _swipeAnimationController,
      curve: Curves.easeOut,
    ));
    
    _swipeAnimationController.addListener(_swipeAnimationListener);
    _swipeAnimationController.forward(from: 0).then((_) {
      _swipeAnimationController.removeListener(_swipeAnimationListener);
      _nextCard();
    });
  }

  void _swipeAnimationListener() {
    setState(() {
      _cardOffset = _swipeAnimation.value;
      _cardAngle = _cardOffset.dx / 1000;
    });
  }

  void _returnToCenter() {
    _returnAnimation = Tween<Offset>(
      begin: _cardOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _returnAnimationController,
      curve: Curves.easeOut,
    ));
    _returnAnimationController.forward(from: 0);
  }

  void _nextCard() {
    setState(() {
      _currentIndex++;
      _cardOffset = Offset.zero;
      _cardAngle = 0;
    });
  }

  void _viewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AthleteDetailScreen(
          athleteId: _athletes[_currentIndex].id,
        ),
      ),
    );
    _returnToCenter();
  }

  void _onShortlist(AthleteCardData athlete) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.bookmark, color: Colors.white),
            const SizedBox(width: 12),
            Text('${athlete.name} shortlisted!'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onSkip(AthleteCardData athlete) {
    // Skip logic - silent
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FiltersSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover Athletes',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Scout Mode',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _openFilters,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.tune,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Swipe hint
            Text(
              'Swipe right to shortlist • Left to skip',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Card Stack
            Expanded(
              child: _currentIndex >= _athletes.length
                  ? _buildEmptyState()
                  : _buildCardStack(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_score,
                size: 50,
                color: AppTheme.primaryOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'All Caught Up!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'ve reviewed all athletes.\nCheck back later for new talent!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('View Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    return Column(
      children: [
        // Cards
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background cards
              if (_currentIndex + 2 < _athletes.length)
                _buildBackgroundCard(_athletes[_currentIndex + 2], 2),
              if (_currentIndex + 1 < _athletes.length)
                _buildBackgroundCard(_athletes[_currentIndex + 1], 1),
              
              // Top card (draggable)
              GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Transform.translate(
                  offset: _cardOffset,
                  child: Transform.rotate(
                    angle: _cardAngle,
                    child: Stack(
                      children: [
                        _buildAthleteCard(_athletes[_currentIndex]),
                        
                        // Swipe indicators
                        if (_cardOffset.dx > 20)
                          _buildSwipeIndicator(
                            'SHORTLIST',
                            AppTheme.successColor,
                            Icons.bookmark,
                            Alignment.topLeft,
                            (_cardOffset.dx / 100).clamp(0, 1),
                          ),
                        if (_cardOffset.dx < -20)
                          _buildSwipeIndicator(
                            'SKIP',
                            AppTheme.errorColor,
                            Icons.close,
                            Alignment.topRight,
                            (-_cardOffset.dx / 100).clamp(0, 1),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Action Buttons
        _buildActionButtons(),
        
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBackgroundCard(AthleteCardData athlete, int index) {
    final scale = 1 - (index * 0.05);
    final yOffset = index * 12.0;
    
    return Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: 0.6,
          child: _buildAthleteCard(athlete, isBackground: true),
        ),
      ),
    );
  }

  Widget _buildAthleteCard(AthleteCardData athlete, {bool isBackground = false}) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: MediaQuery.of(context).size.height * 0.55,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isBackground ? 0.08 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // Profile Image Section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getSportColor(athlete.sport),
                      _getSportColor(athlete.sport).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Sport Icon Background
                    Center(
                      child: Icon(
                        _getSportIcon(athlete.sport),
                        size: 100,
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    
                    // Performance Score
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppTheme.primaryOrange,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${athlete.performanceScore}',
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
                    
                    // Verified Badge
                    if (athlete.isVerified)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
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
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontSize: 12,
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
            
            // Info Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Age
                    Text(
                      '${athlete.name}, ${athlete.age}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Sport & Position
                    Row(
                      children: [
                        Icon(
                          _getSportIcon(athlete.sport),
                          size: 18,
                          color: _getSportColor(athlete.sport),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${athlete.sport} • ${athlete.position}',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${athlete.city}, ${athlete.state}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Stats Row
                    Row(
                      children: athlete.stats.entries.take(2).map((entry) {
                        return Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeIndicator(
    String text,
    Color color,
    IconData icon,
    Alignment alignment,
    double opacity,
  ) {
    return Positioned(
      top: 20,
      left: alignment == Alignment.topLeft ? 40 : null,
      right: alignment == Alignment.topRight ? 40 : null,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: alignment == Alignment.topLeft ? -0.2 : 0.2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Skip Button
          _buildActionButton(
            icon: Icons.close_rounded,
            color: AppTheme.errorColor,
            size: 60,
            iconSize: 32,
            onTap: _swipeLeft,
          ),
          
          const SizedBox(width: 20),
          
          // View Profile Button
          _buildActionButton(
            icon: Icons.person_outline,
            color: AppTheme.secondaryPurple,
            size: 48,
            iconSize: 24,
            onTap: _viewProfile,
          ),
          
          const SizedBox(width: 20),
          
          // Shortlist Button
          _buildActionButton(
            icon: Icons.bookmark_rounded,
            color: AppTheme.successColor,
            size: 60,
            iconSize: 32,
            onTap: _swipeRight,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: iconSize,
        ),
      ),
    );
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
      case 'basketball':
        return const Color(0xFFE91E63);
      case 'swimming':
        return const Color(0xFF03A9F4);
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
      case 'basketball':
        return Icons.sports_basketball;
      case 'swimming':
        return Icons.pool;
      default:
        return Icons.sports;
    }
  }
}

/// Data class for athlete card
class AthleteCardData {
  final String id;
  final String name;
  final int age;
  final String sport;
  final String position;
  final String city;
  final String state;
  final int performanceScore;
  final bool isVerified;
  final String? imageUrl;
  final Map<String, String> stats;

  AthleteCardData({
    required this.id,
    required this.name,
    required this.age,
    required this.sport,
    required this.position,
    required this.city,
    required this.state,
    required this.performanceScore,
    required this.isVerified,
    this.imageUrl,
    required this.stats,
  });
}
