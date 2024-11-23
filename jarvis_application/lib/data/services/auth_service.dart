import 'package:dio/dio.dart';

import '../../core/constants/api_paths.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Map<String, dynamic>?> signUp(
      String username, String email, String password) async {
    try {
      final response = await dio.post(
        ApiPaths.signUp,
        data: {'username': username, 'email': email, 'password': password},
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

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await dio.post(
        ApiPaths.signIn,
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

  // Google sign in
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final response = await dio.post(ApiPaths.googleSignIn);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(parseError(e.response));
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> refreshTokens(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiPaths.refreshTokens,
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

    // Check if response.data is a Map
    if (response.data is Map) {
      final data = response.data;

      // Extract 'details' and get 'issue' if available
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
