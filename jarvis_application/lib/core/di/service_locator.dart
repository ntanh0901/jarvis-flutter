// lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';

import '../../data/services/api_service.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => ApiService());
}
