import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';
import '../../../ui/widgets/app_button.dart';

/// Filters Bottom Sheet for filtering athletes
class FiltersSheet extends StatefulWidget {
  const FiltersSheet({super.key});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  RangeValues _ageRange = const RangeValues(14, 25);
  RangeValues _scoreRange = const RangeValues(50, 100);
  String? _selectedGender;
  List<String> _selectedSports = [];
  String? _selectedState;
  bool _verifiedOnly = false;

  final List<String> _sports = [
    'Cricket', 'Football', 'Hockey', 'Basketball', 
    'Athletics', 'Swimming', 'Badminton', 'Tennis',
    'Kabaddi', 'Wrestling', 'Boxing', 'Volleyball'
  ];

  final List<String> _states = [
    'Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu',
    'Gujarat', 'Rajasthan', 'West Bengal', 'Punjab',
    'Kerala', 'Telangana', 'Haryana', 'Uttar Pradesh'
  ];

  void _resetFilters() {
    setState(() {
      _ageRange = const RangeValues(14, 25);
      _scoreRange = const RangeValues(50, 100);
      _selectedGender = null;
      _selectedSports = [];
      _selectedState = null;
      _verifiedOnly = false;
    });
  }

  void _applyFilters() {
    // Apply filters and close
    Navigator.pop(context, {
      'ageRange': _ageRange,
      'scoreRange': _scoreRange,
      'gender': _selectedGender,
      'sports': _selectedSports,
      'state': _selectedState,
      'verifiedOnly': _verifiedOnly,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filters Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Age Range
                  _buildSectionTitle('Age Range'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${_ageRange.start.round()} years',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        '${_ageRange.end.round()} years',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _ageRange,
                    min: 10,
                    max: 35,
                    divisions: 25,
                    activeColor: AppTheme.primaryOrange,
                    inactiveColor: AppTheme.primaryOrange.withOpacity(0.2),
                    labels: RangeLabels(
                      '${_ageRange.start.round()}',
                      '${_ageRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() => _ageRange = values);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Performance Score
                  _buildSectionTitle('Performance Score'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${_scoreRange.start.round()}',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        '${_scoreRange.end.round()}',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _scoreRange,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: AppTheme.primaryOrange,
                    inactiveColor: AppTheme.primaryOrange.withOpacity(0.2),
                    labels: RangeLabels(
                      '${_scoreRange.start.round()}',
                      '${_scoreRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() => _scoreRange = values);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Gender
                  _buildSectionTitle('Gender'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildGenderChip('Male'),
                      const SizedBox(width: 12),
                      _buildGenderChip('Female'),
                      const SizedBox(width: 12),
                      _buildGenderChip('All'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sports
                  _buildSectionTitle('Sports'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sports.map((sport) {
                      final isSelected = _selectedSports.contains(sport);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedSports.remove(sport);
                            } else {
                              _selectedSports.add(sport);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppTheme.primaryOrange 
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            sport,
                            style: TextStyle(
                              color: isSelected 
                                  ? Colors.white 
                                  : AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // State
                  _buildSectionTitle('State'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedState,
                        hint: Text(
                          'Select state',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _states.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedState = value);
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Verified Only
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: AppTheme.successColor,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Verified Athletes Only',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Switch(
                          value: _verifiedOnly,
                          onChanged: (value) {
                            setState(() => _verifiedOnly = value);
                          },
                          activeColor: AppTheme.primaryOrange,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Apply Button
          Container(
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
            child: AppPrimaryButton(
              text: 'Apply Filters',
              onPressed: _applyFilters,
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
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildGenderChip(String gender) {
    final isSelected = _selectedGender == gender || 
                       (gender == 'All' && _selectedGender == null);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender == 'All' ? null : gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
