// lib/providers/auth_notifier.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';

import '../data/services/auth_service.dart';
import 'auth_service_provider.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthState get currentState => state;

  AuthNotifier(this._authService) : super(AuthState());

  Future<void> signUp(String username, String email, String password) async {
    try {
      final response = await _authService.signUp(username, email, password);
      if (response != null && response['user'] != null) {
        state = AuthState();
      } else {
        state = state.copyWith(errorMessage: 'Sign-up failed.');
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _authService.signIn(email, password);
      if (response != null && response.containsKey('token')) {
        final accessToken = response['token']['accessToken'];
        final refreshToken = response['token']['refreshToken'];
        await _storage.write(key: 'accessToken', value: accessToken);
        await _storage.write(key: 'refreshToken', value: refreshToken);
        state = state.copyWith(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAuthenticated: true,
          errorMessage: null,
        );
      } else {
        state = state.copyWith(errorMessage: 'Sign-in failed.');
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signOut() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    state = AuthState();
  }

  void updateAccessToken(String newAccessToken) {
    state = state.copyWith(accessToken: newAccessToken);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
