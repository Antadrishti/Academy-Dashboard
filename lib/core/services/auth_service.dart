import 'dart:convert';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<User> login(String phone, String password) async {
    final response = await _apiService.post(
      '/auth/login',
      body: {
        'phone': phone,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _apiService.setToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<User> register({
    required String phone,
    required String password,
    required String role,
    Map<String, dynamic>? additionalData,
  }) async {
    final body = {
      'phone': phone,
      'password': password,
      'role': role,
      ...?additionalData,
    };

    final response = await _apiService.post(
      '/auth/register',
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _apiService.setToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Ignore errors on logout
    } finally {
      _apiService.clearToken();
    }
  }

  Future<User> getCurrentUser() async {
    final response = await _apiService.get('/auth/me');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to get current user');
    }
  }

  Future<void> requestOTP(String phone) async {
    final response = await _apiService.post(
      '/auth/otp/request',
      body: {'phone': phone},
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to send OTP');
    }
  }

  Future<User> verifyOTP(String phone, String otp) async {
    final response = await _apiService.post(
      '/auth/otp/verify',
      body: {
        'phone': phone,
        'otp': otp,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _apiService.setToken(data['token']);
      return User.fromJson(data['user']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'OTP verification failed');
    }
  }
}

