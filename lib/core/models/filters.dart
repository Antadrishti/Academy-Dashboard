/// Filter model for browsing and searching athletes
/// Used by academies to filter athletes based on various criteria
class AthleteFilters {
  /// Minimum age for filtering athletes
  final int? minAge;
  
  /// Maximum age for filtering athletes
  final int? maxAge;
  
  /// Gender filter: 'Male', 'Female', or 'Other'
  final String? gender;
  
  /// List of sports to filter by (e.g., ['Cricket', 'Football'])
  final List<String>? sports;
  
  /// City filter for location-based search
  final String? city;
  
  /// State filter for location-based search
  final String? state;
  
  /// Radius in kilometers from a specific location for proximity search
  final double? radiusKm;
  
  /// Skill level filter: 'beginner', 'intermediate', or 'advanced'
  final String? skillLevel;
  
  /// Minimum performance score threshold
  final double? minPerformanceScore;
  
  /// Maximum performance score threshold
  final double? maxPerformanceScore;
  
  /// Filter to show only verified athletes
  final bool? verifiedOnly;
  
  /// Text search query for athlete name search
  final String? searchQuery;

  /// Creates an AthleteFilters instance
  /// All parameters are optional - only non-null values will be applied as filters
  AthleteFilters({
    this.minAge,
    this.maxAge,
    this.gender,
    this.sports,
    this.city,
    this.state,
    this.radiusKm,
    this.skillLevel,
    this.minPerformanceScore,
    this.maxPerformanceScore,
    this.verifiedOnly,
    this.searchQuery,
  });

  /// Converts filters to JSON map for API requests
  /// Only includes non-null filter values
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (minAge != null) json['minAge'] = minAge;
    if (maxAge != null) json['maxAge'] = maxAge;
    if (gender != null) json['gender'] = gender;
    if (sports != null && sports!.isNotEmpty) json['sports'] = sports;
    if (city != null) json['city'] = city;
    if (state != null) json['state'] = state;
    if (radiusKm != null) json['radiusKm'] = radiusKm;
    if (skillLevel != null) json['skillLevel'] = skillLevel;
    if (minPerformanceScore != null) json['minPerformanceScore'] = minPerformanceScore;
    if (maxPerformanceScore != null) json['maxPerformanceScore'] = maxPerformanceScore;
    if (verifiedOnly != null) json['verifiedOnly'] = verifiedOnly;
    if (searchQuery != null && searchQuery!.isNotEmpty) json['searchQuery'] = searchQuery;
    return json;
  }

  /// Checks if any filters are set
  bool get hasFilters {
    return minAge != null ||
        maxAge != null ||
        gender != null ||
        (sports != null && sports!.isNotEmpty) ||
        city != null ||
        state != null ||
        radiusKm != null ||
        skillLevel != null ||
        minPerformanceScore != null ||
        maxPerformanceScore != null ||
        verifiedOnly == true ||
        (searchQuery != null && searchQuery!.isNotEmpty);
  }

  /// Resets all filters to null
  AthleteFilters clear() {
    return AthleteFilters();
  }

  /// Returns a string representation for debugging
  @override
  String toString() {
    final filters = <String>[];
    if (minAge != null || maxAge != null) {
      filters.add('Age: ${minAge ?? "any"}-${maxAge ?? "any"}');
    }
    if (gender != null) filters.add('Gender: $gender');
    if (sports != null && sports!.isNotEmpty) filters.add('Sports: ${sports!.join(", ")}');
    if (city != null) filters.add('City: $city');
    if (state != null) filters.add('State: $state');
    if (radiusKm != null) filters.add('Radius: ${radiusKm}km');
    if (skillLevel != null) filters.add('Skill: $skillLevel');
    if (minPerformanceScore != null || maxPerformanceScore != null) {
      filters.add('Score: ${minPerformanceScore ?? "any"}-${maxPerformanceScore ?? "any"}');
    }
    if (verifiedOnly == true) filters.add('Verified only');
    if (searchQuery != null && searchQuery!.isNotEmpty) filters.add('Search: "$searchQuery"');
    return filters.isEmpty ? 'No filters' : filters.join(', ');
  }

  /// Creates a copy of this filter with updated values
  /// Only the provided parameters will be updated, others remain the same
  AthleteFilters copyWith({
    int? minAge,
    int? maxAge,
    String? gender,
    List<String>? sports,
    String? city,
    String? state,
    double? radiusKm,
    String? skillLevel,
    double? minPerformanceScore,
    double? maxPerformanceScore,
    bool? verifiedOnly,
    String? searchQuery,
  }) {
    return AthleteFilters(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      gender: gender ?? this.gender,
      sports: sports ?? this.sports,
      city: city ?? this.city,
      state: state ?? this.state,
      radiusKm: radiusKm ?? this.radiusKm,
      skillLevel: skillLevel ?? this.skillLevel,
      minPerformanceScore: minPerformanceScore ?? this.minPerformanceScore,
      maxPerformanceScore: maxPerformanceScore ?? this.maxPerformanceScore,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Options for sorting athlete search results
enum SortOption {
  /// Sort by newest athletes first (default)
  newest,
  
  /// Sort by performance score (highest first)
  performanceScore,
  
  /// Sort by location proximity
  location,
  
  /// Sort by age
  age,
}

