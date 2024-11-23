// base_service.dart
import 'package:dio/dio.dart';

import '../../providers/auth_notifier.dart';

class BaseService {
  final Dio _dio;
  final AuthNotifier _authNotifier;

  BaseService(this._dio, this._authNotifier) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_authNotifier.currentState.accessToken != null) {
          options.headers['Authorization'] =
              'Bearer ${_authNotifier.currentState.accessToken}';
        }
        return handler.next(options);
      },
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
            // Handle token refresh failure
            await _authNotifier.signOut();
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<String?> _refreshAccessToken() async {
    // Implement the logic to refresh the access token using the refresh token
    // This might involve calling an endpoint on your authentication server
    // and updating the AuthNotifier state with the new access token
    // For example:
    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': _authNotifier.currentState.refreshToken,
      });
      final newAccessToken = response.data['accessToken'];
      _authNotifier.updateAccessToken(newAccessToken);
      return newAccessToken;
    } catch (e) {
      return null;
    }
  }

  Dio get dio => _dio;
}
