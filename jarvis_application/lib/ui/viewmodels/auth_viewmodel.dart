// lib/ui/viewmodels/auth_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_notifier.dart';
import '../../providers/auth_notifier_provider.dart';

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthNotifier _authNotifier;

  AuthViewModel(this._authNotifier) : super(const AsyncData(null));

  String? get errorMessage => _authNotifier.state.errorMessage;

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _authNotifier.signIn(email, password);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    state = const AsyncLoading();
    try {
      await _authNotifier.signUp(username, email, password);
      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void logout() {
    _authNotifier.signOut();
    state = const AsyncData(null);
  }

  Future<void> signInWithGoogle() async {
    //   TODO: Implement sign in with Google
  }

  Future<void> googleSignUp() async {
    //   TODO: Implement sign up with Google
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  return AuthViewModel(authNotifier);
});
