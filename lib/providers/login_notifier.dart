import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class LoginState {
  final AuthStatus status;
  final String? errorMessage;

  LoginState({this.status = AuthStatus.initial, this.errorMessage});

  LoginState copyWith({AuthStatus? status, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final ApiClient _apiClient;

  LoginNotifier(this._apiClient) : super(LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _apiClient.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data != null) {
        final token = response.data['token'];
        await _apiClient.saveToken(token);
        state = state.copyWith(status: AuthStatus.authenticated);
      } else {
        state = state.copyWith(status: AuthStatus.error, errorMessage: 'Login failed. Please try again.');
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await _apiClient.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiClient.tokenKey);
    if (token != null) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }
}

final apiClientProvider = Provider((ref) => ApiClient());

final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.watch(apiClientProvider)),
);
