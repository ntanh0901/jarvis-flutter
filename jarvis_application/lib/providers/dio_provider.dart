import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config.dart';
import '../core/constants/api_endpoints.dart';
import '../data/services/token_manager.dart';

final dioProvider = Provider<Dio>((ref) {
  final tokenManager = ref.read(tokenManagerProvider);
  return DioClient(tokenManager).dio;
});

final dioKBProvider = Provider<DioKB>((ref) {
  final tokenManager = ref.read(tokenManagerProvider);
  final dioKB = DioKB(tokenManager);
  dioKB.authenticateWithToken();
  return dioKB;
});

class DioClient {
  final Dio _dio;
  final TokenManager _tokenManager;

  DioClient(this._tokenManager)
      : _dio = Dio(
          BaseOptions(
            baseUrl: Config.baseUrl,
            headers: {
              'x-jarvis-guid': '',
            },
          ),
        ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _handleRequest,
      onError: _handleError,
    ));
  }

  Future<void> _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra['requiresAuth'] ?? true;
    if (requiresAuth) {
      await _addAuthorizationHeader(options);
    }
    handler.next(options);
  }

  Future<void> _handleError(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    if (e.response?.statusCode == 401 &&
        !(e.requestOptions.extra['retried'] ?? false)) {
      try {
        final response = await _handleTokenRefresh(e);
        if (response != null) {
          return handler.resolve(response);
        }
      } catch (error) {
        print('Token refresh failed: $error');
      }
    }
    handler.next(e);
  }

  Future<Response<dynamic>?> _handleTokenRefresh(DioException e) async {
    e.requestOptions.extra['retried'] = true;

    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken == null) return null;

    final newTokens = await _refreshTokens(refreshToken);
    if (newTokens == null) return null;

    _tokenManager.saveTokens(
        accessToken: newTokens['accessToken'],
        refreshToken: newTokens['refreshToken']);

    e.requestOptions.headers['Authorization'] =
        'Bearer ${newTokens['accessToken']}';

    return await _dio.fetch(e.requestOptions);
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
      }
      print('Token refresh failed: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Token refresh error: $e');
      return null;
    }
  }

  Dio get dio => _dio;
}

class DioKB {
  final Dio _dio;
  final TokenManager _tokenManager;

  DioKB(this._tokenManager) : _dio = Dio() {
    _dio.options.baseUrl = Config.kbBaseUrl;
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _handleRequest,
      onError: _handleError,
    ));
  }

  Future<void> _handleRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final requiresAuth = options.extra['requiresAuth'] ?? true;
    if (requiresAuth) {
      await _addKBAuthorizationHeader(options);
    }
    handler.next(options);
  }

  Future<void> _handleError(
      DioException e, ErrorInterceptorHandler handler) async {
    if (e.response?.statusCode == 401 &&
        !(e.requestOptions.extra['retried'] ?? false)) {
      try {
        await authenticateWithToken();
        final kbToken = await _tokenManager.getAccessToken(true);
        if (kbToken != null) {
          e.requestOptions.headers['Authorization'] = 'Bearer $kbToken';
          final response =
              await _dio.fetch(e.requestOptions..extra['retried'] = true);
          return handler.resolve(response);
        }
      } catch (error) {
        print('KB token refresh failed: $error');
      }
    }
    handler.next(e);
  }

  Future<void> _addKBAuthorizationHeader(RequestOptions options) async {
    final kbToken = await _tokenManager.getAccessToken(true);
    if (kbToken != null) {
      options.headers['Authorization'] = 'Bearer $kbToken';
    }
  }

  Future<void> authenticateWithToken() async {
    try {
      final jarvisToken = await _tokenManager.getAccessToken();
      if (jarvisToken == null) throw Exception('No Jarvis token found');

      final response = await _dio.post(
        ApiEndpoints.kbSignIn,
        data: {"token": jarvisToken},
        options: Options(extra: {'requiresAuth': false}),
      );

      if (response.statusCode == 200 && response.data?['token'] != null) {
        final token = response.data['token'];
        print(token['accessToken']);
        _tokenManager.saveTokens(
            accessToken: token['accessToken'],
            refreshToken: token['refreshToken'],
            isKB: true);
      } else {
        throw Exception('KB authentication failed: ${response.statusCode}');
      }
    } catch (e) {
      print('KB Authentication failed: $e');
      rethrow;
    }
  }

  Dio get dio => _dio;
}
