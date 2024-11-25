import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../providers/dio_provider.dart';
import 'token_manager.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(rawDioProvider);
  final tokenManager = ref.read(tokenManagerProvider);
  return AuthService(dio, tokenManager);
});

class AuthService {
  final Dio dio;
  final TokenManager tokenManager;

  AuthService(this.dio, this.tokenManager);

  Future<Map<String, dynamic>?> signUp(
      String username, String email, String password) async {
    try {
      final response = await dio.post(
        ApiEndpoints.signUp,
        data: {'username': username, 'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(parseError(e.response));
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error signing up: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await dio.post(
        ApiEndpoints.signIn,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(parseError(e.response));
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error signing in: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    return null;

    //   TODO: Implement sign in with Google
  }

  Future<Map<String, dynamic>?> signUpWithGoogle() async {
    return null;

    //   TODO: Implement sign up with Google
  }

  Future<void> signOut() async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      if (accessToken == null) {
        throw Exception("No access token found");
      }

      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.get(ApiEndpoints.signOut);
      if (response.statusCode == 200) {
        await tokenManager.deleteTokens();
      } else {
        throw Exception(
            'Sign out failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          // Token expired or invalid, attempt refresh
          final refreshToken = await tokenManager.getRefreshToken();
          if (refreshToken == null) {
            throw Exception("No refresh token found");
          }

          try {
            final tokens = await refreshTokens(refreshToken);
            if (tokens != null) {
              // Retry sign out after refreshing the token
              dio.options.headers['Authorization'] =
                  'Bearer ${tokens['accessToken']}';
              final retryResponse = await dio.get(ApiEndpoints.signOut);
              if (retryResponse.statusCode == 200) {
                await tokenManager.deleteTokens();
              } else {
                throw Exception(
                    'Sign out failed after token refresh, status code: ${retryResponse.statusCode}');
              }
            } else {
              throw Exception("Failed to refresh tokens");
            }
          } catch (refreshError) {
            throw Exception('Failed to refresh tokens: $refreshError');
          }
        } else {
          throw Exception('Failed to sign out: ${e.message}');
        }
      } else {
        throw Exception('An unknown error occurred: $e');
      }
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      if (accessToken == null) {
        throw Exception("No access token found");
      }

      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.get(ApiEndpoints.getCurrentUser);
      return response.data;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        // Token expired or invalid, attempt refresh
        final refreshToken = await tokenManager.getRefreshToken();
        final tokens = await refreshTokens(refreshToken!);
        if (tokens != null) {
          // Save new tokens and retry the original request
          await tokenManager.saveTokens(
              tokens['accessToken'], tokens['refreshToken']);
          return await getCurrentUser(); // Retry the request with new token
        }
      }
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<Map<String, dynamic>?> refreshTokens(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshTokens,
        data: {'refreshToken': refreshToken},
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(parseError(e.response));
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error refreshing token: $e');
    }
    return null;
  }

  String parseError(Response? response) {
    if (response == null || response.data == null) {
      return 'Unknown error occurred';
    }

    if (response.data is Map) {
      final data = response.data;

      if (data.containsKey('details') && data['details'] is List) {
        final details = data['details'];
        if (details.isNotEmpty &&
            details.first is Map &&
            details.first.containsKey('issue')) {
          return details.first['issue'];
        }
      }

      if (data.containsKey('message')) {
        return data['message'];
      }
    }

    return 'Unknown error occurred';
  }
}
