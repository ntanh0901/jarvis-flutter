// lib/repositories/auth_repository.dart

import 'package:dio/dio.dart';

import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Response> signIn(String email, String password) async {
    return await _apiService.post(
      '/api/v1/auth/sign-in',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> signUp(
      String username, String email, String password) async {
    return await _apiService.post(
      '/api/v1/auth/sign-up',
      data: {'username': username, 'email': email, 'password': password},
    );
  }

  Future<Response> signOut() async {
    return await _apiService.post('/api/v1/auth/sign-out');
  }

  Future<Response> getUserProfile() async {
    return await _apiService.get('/api/v1/auth/me');
  }
}
