import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/auth_service.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  final authService = ref.read(authProvider.notifier);
  return AuthViewModel(authService);
});

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(const AsyncData(null));

  String? get errorMessage => _authService.state.errorMessage;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _authService.signIn(email, password);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    state = const AsyncLoading();
    try {
      await _authService.signUp(username, email, password);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _authService.signInWithGoogle();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> getCurrentUser() async {
    state = const AsyncLoading();
    try {
      await _authService.getCurrentUser();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
