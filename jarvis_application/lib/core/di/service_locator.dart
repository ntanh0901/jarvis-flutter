// lib/core/di/service_locator.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jarvis_application/data/services/auth_service.dart';

import '../../config/config.dart';
import '../../data/repositories/auth_repository.dart';
import '../../providers/auth_provider.dart';

// GetIt instance for dependency injection
final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() {
    return Dio(BaseOptions(
      baseUrl: Config.apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  });

  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<Dio>()));

  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<AuthService>()));
  getIt.registerFactory<AuthProvider>(
      () => AuthProvider(getIt<AuthRepository>()));
}
