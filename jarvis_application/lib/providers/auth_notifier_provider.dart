import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/providers/user_manager_provider.dart';

import 'auth_notifier.dart';
import 'auth_service_provider.dart';
import 'auth_state.dart';
import 'token_manager_provider.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);
  final userManager = ref.read(userManagerProvider);
  return AuthNotifier(authService, tokenManager, userManager);
});
