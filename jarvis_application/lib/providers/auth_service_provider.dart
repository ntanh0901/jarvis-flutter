import 'package:riverpod/riverpod.dart';

import '../data/services/auth_service.dart';
import 'dio_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio);
});
