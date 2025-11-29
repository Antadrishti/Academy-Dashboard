import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';
import 'athlete_detail_screen.dart';
import 'filters_sheet.dart';
import 'scout_mode_screen.dart';

/// Athlete Browse Screen - Grid/List view of athletes with filters
class AthleteBrowseScreen extends StatefulWidget {
  const AthleteBrowseScreen({super.key});

  @override
  State<AthleteBrowseScreen> createState() => _AthleteBrowseScreenState();
}

class _AthleteBrowseScreenState extends State<AthleteBrowseScreen> {
  final _searchController = TextEditingController();
  bool _isGridView = true;
  bool _isLoading = false;
  String _searchQuery = '';
  
  // Mock data
  final List<AthleteCardData> _athletes = [
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
    AthleteCardData(
      id: '6',
      name: 'Ananya Nair',
      age: 15,
      sport: 'Swimming',
      position: 'Freestyle',
      city: 'Kochi',
      state: 'Kerala',
      performanceScore: 91,
      isVerified: true,
      imageUrl: null,
      stats: {'Best Time': '58.2s', 'State Rank': '#1'},
    ),
  ];

  List<AthleteCardData> get _filteredAthletes {
    if (_searchQuery.isEmpty) return _athletes;
    return _athletes.where((athlete) {
      return athlete.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          athlete.sport.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          athlete.city.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Browse Athletes',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              color: AppTheme.textPrimary,
            ),
            onPressed: () {
              setState(() => _isGridView = !_isGridView);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search athletes...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _openFilters,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Athletes Grid/List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAthletes.isEmpty
                    ? _buildEmptyState()
                    : _isGridView
                        ? _buildGridView()
                        : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No athletes found',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredAthletes.length,
      itemBuilder: (context, index) {
        return _buildAthleteGridCard(_filteredAthletes[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredAthletes.length,
      itemBuilder: (context, index) {
        return _buildAthleteListCard(_filteredAthletes[index]);
      },
    );
  }

  Widget _buildAthleteGridCard(AthleteCardData athlete) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AthleteDetailScreen(athleteId: athlete.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _getSportColor(athlete.sport).withOpacity(0.2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getSportIcon(athlete.sport),
                        size: 48,
                        color: _getSportColor(athlete.sport),
                      ),
                    ),
                    if (athlete.isVerified)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified,
                            color: AppTheme.successColor,
                            size: 16,
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppTheme.primaryOrange,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${athlete.performanceScore}',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${athlete.sport} • ${athlete.age}y',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            athlete.city,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  Widget _buildAthleteListCard(AthleteCardData athlete) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AthleteDetailScreen(athleteId: athlete.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _getSportColor(athlete.sport).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getSportIcon(athlete.sport),
                color: _getSportColor(athlete.sport),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          athlete.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (athlete.isVerified)
                        Icon(
                          Icons.verified,
                          color: AppTheme.successColor,
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${athlete.sport} • ${athlete.position} • ${athlete.age}y',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${athlete.city}, ${athlete.state}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppTheme.primaryOrange,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${athlete.performanceScore}',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
