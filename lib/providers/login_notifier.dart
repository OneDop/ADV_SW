import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/services/api_client.dart';
import 'package:advsw/services/auth_service.dart';
import 'package:advsw/providers/auth_provider.dart';

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
  final AuthService _authService;

  LoginNotifier(this._authService) : super(LoginState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final success = await _authService.login(email, password);
      if (success) {
        state = state.copyWith(status: AuthStatus.authenticated);
      } else {
        state = state.copyWith(status: AuthStatus.error, errorMessage: 'Login failed. Please try again.');
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }
}

final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.watch(authServiceProvider)),
);
