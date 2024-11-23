import 'package:dio/dio.dart';

import '../../providers/auth_notifier.dart';
import '../services/auth_service.dart';

class BaseService {
  final Dio _dio;
  final AuthNotifier _authNotifier;
  final AuthService _authService;

  BaseService(this._dio, this._authNotifier, this._authService) {
    // Add an interceptor to the Dio instance
    _dio.interceptors.add(InterceptorsWrapper(
      // Intercept requests to add the Authorization header if accessToken is available
      onRequest: (options, handler) async {
        if (_authNotifier.currentState.accessToken != null) {
          options.headers['Authorization'] =
              'Bearer ${_authNotifier.currentState.accessToken}';
        }
        return handler.next(options);
      },
      // Intercept errors to handle token refresh if a 401 error occurs
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            _authNotifier.currentState.refreshToken != null) {
          // Attempt to refresh the access token
          try {
            final newAccessToken = await _refreshAccessToken();
            if (newAccessToken != null) {
              // Update the request with the new access token
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
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
          } catch (e) {
            // Handle token refresh failure by signing out
            await _authNotifier.signOut();
          }
        }
        return handler.next(error);
      },
    ));
  }

  // Method to refresh the access token using AuthService
  Future<String?> _refreshAccessToken() async {
    try {
      final response = await _authService
          .refreshTokens(_authNotifier.currentState.refreshToken!);
      if (response != null && response.containsKey('accessToken')) {
        final newAccessToken = response['accessToken'];
        _authNotifier.updateAccessToken(newAccessToken);
        return newAccessToken;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Getter for the Dio instance
  Dio get dio => _dio;
}
