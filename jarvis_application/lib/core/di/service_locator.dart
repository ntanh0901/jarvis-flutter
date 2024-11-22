// lib/core/di/service_locator.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../config/config.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/api_service.dart';
import '../../providers/auth_provider.dart';

// GetIt instance for dependency injection
final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() {
    return Dio(BaseOptions(
      baseUrl: Config.apiUrl, // Fetch the base URL from the Config class
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  });

  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<ApiService>()));
  getIt.registerFactory<AuthProvider>(
      () => AuthProvider(getIt<AuthRepository>()));
}
