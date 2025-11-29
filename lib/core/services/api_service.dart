import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api'; // Update with your backend URL
  static const String _tokenKey = 'auth_token';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = _getHeaders();
    final token = await _getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final finalUri = queryParams != null && queryParams.isNotEmpty
        ? uri.replace(queryParameters: queryParams)
        : uri;

    final response = await http.get(
      finalUri,
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 401) {
      await _clearToken();
      throw Exception('Unauthorized - Please login again');
    }

    return response;
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getAuthHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 401) {
      await _clearToken();
      throw Exception('Unauthorized - Please login again');
    }

    return response;
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getAuthHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 401) {
      await _clearToken();
      throw Exception('Unauthorized - Please login again');
    }

    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 401) {
      await _clearToken();
      throw Exception('Unauthorized - Please login again');
    }

    return response;
  }

  Future<http.Response> postMultipart(
    String endpoint,
    String fieldName,
    List<int> fileBytes,
    String fileName, {
    Map<String, String>? additionalFields,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);
    
    final headers = await _getAuthHeaders();
    request.headers.addAll(headers);
    request.headers.remove('Content-Type'); // Let multipart set it

    request.files.add(
      http.MultipartFile.fromBytes(
        fieldName,
        fileBytes,
        filename: fileName,
      ),
    );

    if (additionalFields != null) {
      request.fields.addAll(additionalFields);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 401) {
      await _clearToken();
      throw Exception('Unauthorized - Please login again');
    }

    return response;
  }

  void setToken(String token) {
    _saveToken(token);
  }

  void clearToken() {
    _clearToken();
  }
}


