import 'package:advsw/models/auth_model.dart';
import 'package:advsw/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _apiClient;
  static const String _tokenKey = 'auth_token';

  AuthService(this._apiClient);

  Future<bool> login(String email, String password) async {
    try {
      final request = AuthenticationRequest(email: email, password: password);
      final response = await _apiClient.post('/auth/authenticate', data: request.toJson());

      if (response.statusCode == 200) {
        final authResponse = AuthenticationResponse.fromJson(response.data);
        final token = authResponse.token;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      final response = await _apiClient.post('/auth/register', data: request.toJson());

      if (response.statusCode == 200) {
        final authResponse = AuthenticationResponse.fromJson(response.data);
        final token = authResponse.token;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      final response = await _apiClient.post('/auth/forgot-password', data: request.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    try {
      final request = ResetPasswordRequest(token: token, newPassword: newPassword);
      final response = await _apiClient.post('/auth/reset-password', data: request.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Make logout request to invalidate session on server
      // Token is automatically included via interceptor
      await _apiClient.post('/auth/logout');
    } catch (e) {
      // Log error but continue with local cleanup
      print("Backend logout failed: $e");
    } finally {
      // Always clear token locally, even if server request fails
      // This also removes it from Dio headers
      await _apiClient.clearToken();
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }
}
