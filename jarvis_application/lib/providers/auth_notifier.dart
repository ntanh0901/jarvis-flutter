import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/auth_service.dart';
import '../data/services/token_manager.dart';
import '../data/services/user_manager.dart';
import 'auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);
  final userManager = ref.read(userManagerProvider);
  return AuthNotifier(authService, tokenManager, userManager);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final TokenManager _tokenManager;
  final UserManager _userManager;

  AuthNotifier(this._authService, this._tokenManager, this._userManager)
      : super(AuthState());

  Future<void> signUp(String username, String email, String password) async {
    state = AuthState();
    try {
      final response = await _authService.signUp(username, email, password);
    } catch (e) {
      state = state.copyWith(
          errorMessage: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState();
    try {
      final response = await _authService.signIn(email, password);
      if (response != null) {
        final token = response['token'];
        final accessToken = token['accessToken'];
        final refreshToken = token['refreshToken'];
        await _tokenManager.saveTokens(accessToken, refreshToken);
        state = state.copyWith(isAuthenticated: true);
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signInWithGoogle() async {
    //   TODO: Implement sign in with Google
  }

  Future<void> signUpWithGoogle() async {
    //   TODO: Implement sign up with Google
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _userManager.getCurrentUser();
      if (user != null) {
        state = state.copyWith(user: user);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    await _tokenManager.deleteTokens();
    await _userManager.deleteUser();
    state = state.copyWith(isAuthenticated: false, user: null);
  }
}
