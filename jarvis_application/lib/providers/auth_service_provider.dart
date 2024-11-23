// auth_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/auth_service.dart';
import 'dio_provider.dart';
import 'token_manager_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(rawDioProvider);
  final tokenManager = ref.read(tokenManagerProvider);
  return AuthService(dio, tokenManager);
});
