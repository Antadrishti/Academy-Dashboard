import 'dart:convert';
import '../models/athlete.dart';
import '../models/test_result.dart';
import 'api_service.dart';

class AthleteService {
  final ApiService _apiService = ApiService();

  Future<Athlete> getProfile() async {
    final response = await _apiService.get('/athlete/profile');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Athlete.fromJson(data['athlete']);
    } else {
      throw Exception('Failed to fetch athlete profile');
    }
  }

  Future<List<TestResult>> getTestResults() async {
    final response = await _apiService.get('/athlete/tests');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['testResults'] as List)
          .map((json) => TestResult.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch test results');
    }
  }

  Future<List<Video>> getVideos() async {
    final response = await _apiService.get('/athlete/videos');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['videos'] as List)
          .map((json) => Video.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch videos');
    }
  }
}


