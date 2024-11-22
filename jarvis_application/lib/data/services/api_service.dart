// lib/data/services/api_service.dart

import 'package:dio/dio.dart';

import '../../providers/auth_provider.dart';

// Interceptors for Access Token
// To automatically attach the accessToken to API requests:

class ApiService {
  final Dio _dio;
  final AuthProvider _authProvider;

  ApiService(this._dio, this._authProvider) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add access token to headers
        if (_authProvider.accessToken != null) {
          options.headers['Authorization'] =
              'Bearer ${_authProvider.accessToken}';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 errors and refresh token
        if (error.response?.statusCode == 401 &&
            _authProvider.refreshToken != null) {
          await _authProvider.refreshTokens();
          // Retry the failed request with a new token
          error.requestOptions.headers['Authorization'] =
              'Bearer ${_authProvider.accessToken}';
          final cloneReq = await _dio.request(
            error.requestOptions.path,
            options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers,
            ),
            data: error.requestOptions.data,
            queryParameters: error.requestOptions.queryParameters,
          );
          return handler.resolve(cloneReq);
        }
        return handler.next(error);
      },
    ));
  }
}
