import 'package:flutter/material.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/theme/app_theme.dart';

class AthleteManagementScreen extends StatefulWidget {
  const AthleteManagementScreen({super.key});

  @override
  State<AthleteManagementScreen> createState() => _AthleteManagementScreenState();
}

class _AthleteManagementScreenState extends State<AthleteManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Athlete Management',
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Shortlisted'),
              Tab(text: 'Selected'),
              Tab(text: 'Rejected'),
              Tab(text: 'Waitlisted'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAthleteList('All'),
                _buildAthleteList('Shortlisted'),
                _buildAthleteList('Selected'),
                _buildAthleteList('Rejected'),
                _buildAthleteList('Waitlisted'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAthleteList(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No $status athletes',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


