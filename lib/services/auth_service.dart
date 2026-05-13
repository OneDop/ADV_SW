import 'package:advsw/models/auth_model.dart';
import 'package:advsw/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  static const String _tokenKey = 'auth_token';

  Future<bool> login(String email, String password) async {
    try {
      final request = AuthenticationRequest(email: email, password: password);
      // Fixed endpoint to /auth/authenticate based on Spring controller
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
