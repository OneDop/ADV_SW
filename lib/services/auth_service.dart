import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _mockToken = 'mock_demo_token';

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, _mockToken);
    return true;
  }

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, _mockToken);
    return true;
  }

  Future<Map<String, dynamic>?> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return {'message': 'Reset link sent (demo mode — no email delivered).'};
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }
}
