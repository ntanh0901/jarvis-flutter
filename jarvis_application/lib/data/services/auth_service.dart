import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/api_endpoints.dart';
import '../../providers/dio_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});

class AuthService {
  final Dio _dio;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._dio);

  Future<Map<String, dynamic>?> signUp(
      String username, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signUp,
        options: Options(extra: {'requiresAuth': false}),
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
      final response = await _dio.post(
        ApiEndpoints.signIn,
        options: Options(extra: {'requiresAuth': false}),
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
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }
      log(googleUser.email);
      log(googleUser.id);
      log(googleUser.photoUrl.toString());

      final googleAuth = await googleUser.authentication;

      final response = await _dio.post(
        ApiEndpoints.googleSignIn,
        options: Options(extra: {'requiresAuth': false}),
        data: {'token': googleAuth.accessToken},
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
      throw Exception('Error signing in with Google: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> signUpWithGoogle() async {
    return null;

    //   TODO: Implement sign up with Google
  }

  Future<void> signOut() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.signOut,
        options: Options(extra: {'requiresAuth': false}),
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
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getCurrentUser,
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
