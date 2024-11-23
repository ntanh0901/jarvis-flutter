import 'package:dio/dio.dart';
import 'package:jarvis_application/providers/token_manager_provider.dart';
import 'package:riverpod/riverpod.dart';

import '../config/config.dart';
import 'auth_service_provider.dart';

// Raw Dio Provider without interceptors
final rawDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: Config.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
});

// Dio Provider with Interceptors
final dioProvider = Provider<Dio>((ref) {
  final dio = ref.read(rawDioProvider); // Use raw Dio as base
  final tokenManager = ref.read(tokenManagerProvider);
  final authService = ref.read(authServiceProvider);
  bool isRefreshing = false;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await tokenManager.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        handler.next(options); // Continue with the request
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 && !isRefreshing) {
          isRefreshing = true;
          try {
            final refreshToken = await tokenManager.getRefreshToken();
            if (refreshToken != null) {
              final tokens = await authService.refreshTokens(refreshToken);
              if (tokens != null) {
                final newAccessToken = tokens['accessToken']!;
                final newRefreshToken = tokens['refreshToken']!;
                // Save the new tokens securely
                await tokenManager.saveTokens(newAccessToken, newRefreshToken);
                // Retry the original request with the new access token
                e.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                final cloneReq = await dio.fetch(e.requestOptions);
                handler.resolve(cloneReq);
                return;
              }
            }
          } catch (refreshError) {
            print('Error refreshing token: $refreshError');
          } finally {
            isRefreshing = false;
          }
        }
        handler.next(e); // Pass the error to the caller
      },
    ),
  );

  return dio;
});
