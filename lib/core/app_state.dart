import 'package:flutter/foundation.dart';
import 'models/user.dart';
import 'services/auth_service.dart';

class AppState extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isAcademy => _currentUser?.role == 'academy';
  bool get isAthlete => _currentUser?.role == 'athlete';
  bool get isAdmin => _currentUser?.role == 'sai_admin';

  final AuthService _authService = AuthService();

  Future<bool> login(String phone, String password) async {
    _setLoading(true);
    _error = null;
    try {
      _currentUser = await _authService.login(phone, password);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String phone,
    required String password,
    required String role,
    Map<String, dynamic>? additionalData,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      _currentUser = await _authService.register(
        phone: phone,
        password: password,
        role: role,
        additionalData: additionalData,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

