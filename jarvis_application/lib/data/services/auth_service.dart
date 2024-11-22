import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  // Parse error messages from API responses
  String parseError(Response<dynamic>? response) {
    if (response == null || response.data == null) {
      return "Unknown error occurred.";
    }
    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('details')) {
      final details = data['details'];
      if (details is List && details.isNotEmpty) {
        return details[0]['issue'] ?? "Unknown error occurred.";
      }
    }
    return data['message'] ?? "Unknown error occurred.";
  }

  // Sign-in method
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/sign-in',
        data: {
          'email': email,
          'password': password,
        },
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

  // Sign-up method
  Future<Map<String, dynamic>?> signUp(
      String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/sign-up',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
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
      throw Exception('Error signing up: $e');
    }
    return null;
  }

  // Refresh token method
  Future<Map<String, dynamic>?> refreshTokens(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/refresh',
        data: {
          'refreshToken': refreshToken,
        },
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
}
