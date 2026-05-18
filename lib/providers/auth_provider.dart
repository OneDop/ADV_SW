import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:advsw/services/auth_service.dart';
import 'package:advsw/services/api_client.dart';
import 'package:advsw/providers/user_provider.dart';

/// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(apiClientProvider));
});

/// AsyncNotifier to manage the authentication state
class AuthNotifier extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    return ref.watch(authServiceProvider).isLoggedIn();
  }

  /// Login the user and update authentication state
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await ref.read(authServiceProvider).login(email, password);
    state = AsyncValue.data(result);
    if (result) {
      ref.invalidate(userProfileProvider);
    }
    return result;
  }

  /// Sign up a new user and update authentication state
  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await ref.read(authServiceProvider).signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    state = AsyncValue.data(result);
    if (result) {
      ref.invalidate(userProfileProvider);
    }
    return result;
  }

  /// Logout the user and update authentication state
  Future<void> logout() async {
    state = const AsyncValue.loading();
    await ref.read(authServiceProvider).logout();
    state = const AsyncValue.data(false);
  }

  /// Handle forgot password request
  Future<bool> forgotPassword(String email) async {
    return ref.read(authServiceProvider).forgotPassword(email);
  }

  /// Handle reset password request
  Future<bool> resetPassword(String token, String newPassword) async {
    return ref.read(authServiceProvider).resetPassword(token, newPassword);
  }
}

/// Provider for the authentication state
final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);
