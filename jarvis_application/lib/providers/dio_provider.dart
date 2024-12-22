import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config.dart';
import '../core/constants/api_endpoints.dart';
import '../data/services/token_manager.dart';

final dioProvider = Provider<Dio>((ref) {
  final tokenManager = ref.read(tokenManagerProvider);
  return DioClient(tokenManager)._dio;
});

final dioKBProvider = Provider<DioKB>((ref) {
  final dioClient = ref.read(dioProvider);
  final dioKB = DioKB();
  dioKB.authenticateWithToken(dioClient); // Thực hiện xác thực
  return dioKB;
});



class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Config.baseUrl,
      headers: {
        'x-jarvis-guid': '',
      },
    ),
  );
  final TokenManager _tokenManager;

  DioClient(this._tokenManager) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        bool requiresAuth = options.extra['requiresAuth'] ?? true;
        if (requiresAuth) {
          await _addAuthorizationHeader(options);
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 &&
            !(e.requestOptions.extra['retried'] ?? false)) {
          e.requestOptions.extra['retried'] = true;

          final refreshToken = await _tokenManager.getRefreshToken();
          if (refreshToken != null) {
            final newAccessToken = await _refreshTokens(refreshToken);
            if (newAccessToken != null) {
              final accessToken = newAccessToken['accessToken'];
              await _tokenManager.saveTokens(newAccessToken,
                  isSaveRefreshToken: false);

              e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';

              final retryResponse = await _dio.request(
                e.requestOptions.path,
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers,
                  contentType: e.requestOptions.contentType,
                  extra: e.requestOptions.extra,
                ),
                data: e.requestOptions.data,
              );
              return handler.resolve(retryResponse);
            }
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> _addAuthorizationHeader(RequestOptions options) async {
    final accessToken = await _tokenManager.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  Future<Map<String, dynamic>?> _refreshTokens(String refreshToken) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.refreshToken,
        options: Options(extra: {'requiresAuth': false}),
        queryParameters: {'refreshToken': refreshToken},
      );
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        print('Failed to refresh token. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Dio get dio => _dio;
}


class DioKB {
  final Dio _dio = Dio();

  DioKB() {
    _dio.options
      ..baseUrl = 'https://knowledge-api.jarvis.cx'
      ..headers = {'Content-Type': 'application/json'};
  }

  Future<void> authenticateWithToken(Dio dioClient) async {
    try {
      final tokenResponse = await dioClient.get('/path/to/your/token'); // Adjust with actual token endpoint
      final token = tokenResponse.data['accessToken'];

      // Authenticate the KB client
      final response = await _dio.post(
        '/kb-core/v1/auth/external-sign-in',
        data: {
          "token": token,
        },
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['token']['accessToken'];
        _dio.options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        print('Failed to authenticate DioKB: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during DioKB authentication: $e');
    }
  }

  Dio get dio => _dio;
}
