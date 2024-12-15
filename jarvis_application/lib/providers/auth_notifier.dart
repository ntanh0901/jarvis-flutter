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

  // Helper method to handle error and update state
  void _handleError(String error) {
    state = state.copyWith(
      errorMessage: error.replaceFirst('Exception: ', ''),
    );
  }

  // Helper method to update authentication state
  void _setAuthenticatedState(Map<String, dynamic> response) {
    final tokens = response['token'];
    _tokenManager.saveTokens(tokens); // Save tokens
    state = state.copyWith(isAuthenticated: true);
  }

  // SignUp method
  Future<void> signUp(String username, String email, String password) async {
    state = AuthState(); // Reset state before action
    try {
      final response = await _authService.signUp(username, email, password);
      _setAuthenticatedState(response!);
    } catch (e) {
      _handleError(e.toString());
    }
  }

  // SignIn method
  Future<void> signIn(String email, String password) async {
    state = AuthState(); // Reset state before action
    try {
      final response = await _authService.signIn(email, password);
      if (response != null) {
        _setAuthenticatedState(response);
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  // SignIn with Google (TODO: Implement sign-in)
  Future<void> signInWithGoogle() async {
    // Implement Google sign-in logic here
  }

  // SignUp with Google (TODO: Implement sign-up)
  Future<void> signUpWithGoogle() async {
    // Implement Google sign-up logic here
  }

  // Get current user info
  Future<void> getCurrentUser() async {
    try {
      final user = await _userManager.getCurrentUser();
      if (user != null) {
        state = state.copyWith(user: user);
      }
    } catch (e) {
      _handleError(e.toString());
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _tokenManager.deleteTokens();
      await _userManager.deleteUser();
      state = state.copyWith(isAuthenticated: false, user: null);
    } catch (e) {
      _handleError(e.toString());
    }
  }
}
