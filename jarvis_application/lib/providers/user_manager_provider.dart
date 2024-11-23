// lib/providers/user_manager_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/user_manager.dart';
import 'auth_service_provider.dart';

final userManagerProvider = Provider<UserManager>((ref) {
  final authService = ref.read(authServiceProvider);
  return UserManager(authService);
});
