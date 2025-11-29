import 'dart:convert';
import '../models/athlete.dart';
import '../models/filters.dart';
import '../models/achievement.dart';
import 'api_service.dart';

class DashboardData {
  final int totalAthletesViewed;
  final int shortlistedCount;
  final int selectedCount;
  final int pendingApplications;
  final List<Map<String, dynamic>> recentActivity;

  DashboardData({
    required this.totalAthletesViewed,
    required this.shortlistedCount,
    required this.selectedCount,
    required this.pendingApplications,
    required this.recentActivity,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalAthletesViewed: json['totalAthletesViewed'] ?? 0,
      shortlistedCount: json['shortlistedCount'] ?? 0,
      selectedCount: json['selectedCount'] ?? 0,
      pendingApplications: json['pendingApplications'] ?? 0,
      recentActivity: List<Map<String, dynamic>>.from(json['recentActivity'] ?? []),
    );
  }
}

class Analytics {
  final Map<String, dynamic> performanceTrends;
  final Map<String, dynamic> comparisons;
  final List<Map<String, dynamic>> recommendations;

  Analytics({
    required this.performanceTrends,
    required this.comparisons,
    required this.recommendations,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      performanceTrends: json['performanceTrends'] ?? {},
      comparisons: json['comparisons'] ?? {},
      recommendations: List<Map<String, dynamic>>.from(json['recommendations'] ?? []),
    );
  }
}

class AcademyService {
  final ApiService _apiService = ApiService();

  Future<List<Athlete>> browseAthletes({
    AthleteFilters? filters,
    SortOption sortBy = SortOption.newest,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'sortBy': sortBy.toString().split('.').last,
    };

    if (filters != null) {
      final filterJson = filters.toJson();
      filterJson.forEach((key, value) {
        if (value != null) {
          if (value is List) {
            queryParams[key] = value.join(',');
          } else {
            queryParams[key] = value.toString();
          }
        }
      });
    }

    final response = await _apiService.get('/academy/athletes', queryParams: queryParams);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['athletes'] as List)
          .map((json) => Athlete.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch athletes');
    }
  }

  Future<Athlete> getAthleteProfile(String athleteId) async {
    final response = await _apiService.get('/academy/athletes/$athleteId');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Athlete.fromJson(data['athlete']);
    } else {
      throw Exception('Failed to fetch athlete profile');
    }
  }

  Future<void> shortlistAthlete(String athleteId) async {
    final response = await _apiService.post(
      '/academy/athletes/$athleteId/shortlist',
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to shortlist athlete');
    }
  }

  Future<void> selectAthlete(String athleteId) async {
    final response = await _apiService.post(
      '/academy/athletes/$athleteId/select',
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to select athlete');
    }
  }

  Future<void> rejectAthlete(String athleteId) async {
    final response = await _apiService.post(
      '/academy/athletes/$athleteId/reject',
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to reject athlete');
    }
  }

  Future<void> sendMessage(String athleteId, String message) async {
    final response = await _apiService.post(
      '/academy/messaging/send',
      body: {
        'to': athleteId,
        'content': message,
        'type': 'message',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to send message');
    }
  }

  Future<DashboardData> getDashboard() async {
    final response = await _apiService.get('/academy/dashboard');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DashboardData.fromJson(data);
    } else {
      throw Exception('Failed to fetch dashboard data');
    }
  }

  Future<void> uploadAchievement(Achievement achievement) async {
    final response = await _apiService.post(
      '/academy/achievements',
      body: achievement.toJson(),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to upload achievement');
    }
  }

  Future<Analytics> getAnalytics() async {
    final response = await _apiService.get('/academy/analytics');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Analytics.fromJson(data);
    } else {
      throw Exception('Failed to fetch analytics');
    }
  }

  Future<List<Athlete>> getShortlistedAthletes() async {
    final response = await _apiService.get('/academy/athletes/shortlisted');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['athletes'] as List)
          .map((json) => Athlete.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch shortlisted athletes');
    }
  }

  Future<List<Athlete>> getSelectedAthletes() async {
    final response = await _apiService.get('/academy/athletes/selected');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['athletes'] as List)
          .map((json) => Athlete.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch selected athletes');
    }
  }
}

