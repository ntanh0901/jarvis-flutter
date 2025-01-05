import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/api_endpoints.dart';
import '../../providers/auth_state.dart';
import '../../providers/dio_provider.dart';
import '../services/token_manager.dart';
import '../services/user_manager.dart';

final authProvider = StateNotifierProvider<AuthService, AuthState>((ref) {
  final dio = ref.read(dioProvider);
  final tokenManager = ref.read(tokenManagerProvider);
  final userManager = ref.read(userManagerProvider);
  return AuthService(dio, tokenManager, userManager);
});

class AuthService extends StateNotifier<AuthState> {
  final Dio _dio;
  final TokenManager _tokenManager;
  final UserManager _userManager;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._dio, this._tokenManager, this._userManager)
      : super(AuthState());

  void _handleError(String error) {
    state = state.copyWith(
      errorMessage: error.replaceFirst('Exception: ', ''),
    );
  }

  void _setAuthenticatedState(Map<String, dynamic> response) {
    final tokens = response['token'];
    _tokenManager.saveTokens(
        accessToken: tokens['accessToken'],
        refreshToken: tokens['refreshToken']);
    state = state.copyWith(isAuthenticated: true);
  }

  Future<void> signUp(String username, String email, String password) async {
    state = AuthState();
    try {
      final response = await _dio.post(
        ApiEndpoints.signUp,
        options: Options(extra: {'requiresAuth': false}),
        data: {'username': username, 'email': email, 'password': password},
      );
      if (response.statusCode == 201) {
        _setAuthenticatedState(response.data);
      }
    } catch (e) {
      _handleError(_parseError(e));
    }
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState();
    try {
      final response = await _dio.post(
        ApiEndpoints.signIn,
        options: Options(extra: {'requiresAuth': false}),
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        _setAuthenticatedState(response.data);
      }
    } catch (e) {
      _handleError(_parseError(e));
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthState();
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in aborted');

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
        _setAuthenticatedState(response.data);
      }
    } catch (e) {
      _handleError(_parseError(e));
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getCurrentUser,
      );

      if (response.statusCode == 200) {
        final user = response.data;
        state = state.copyWith(user: user, isAuthenticated: true);
      }
    } catch (e) {
      _handleError(_parseError(e));
    }
  }

  Future<void> signOut() async {
    try {
      await _dio.get(
        ApiEndpoints.signOut,
        options: Options(extra: {'requiresAuth': false}),
      );
      await _tokenManager.deleteAllTokens();
      await _userManager.deleteUser();
      state = state.copyWith(isAuthenticated: false, user: null);
    } catch (e) {
      _handleError(_parseError(e));
    }
  }

  String _parseError(dynamic error) {
    if (error is DioException && error.response != null) {
      final response = error.response;
      if (response?.data == null) return 'Unknown error occurred';

      if (response!.data is Map) {
        final data = response.data;
        if (data['details'] is List && data['details'].isNotEmpty) {
          final details = data['details'].first;
          if (details is Map && details.containsKey('issue')) {
            return details['issue'];
          }
        }
        if (data.containsKey('message')) return data['message'];
      }
    }
    return error.toString();
  }
}
