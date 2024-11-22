// lib/providers/auth_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isAuthenticated = false;
  String? _errorMessage;

  AuthProvider(this._authRepository);

  bool get isAuthenticated => _isAuthenticated;

  String? get errorMessage => _errorMessage;

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _authRepository.signIn(email, password);
      if (response.statusCode == 200) {
        _isAuthenticated = true;
        _errorMessage = null;
      } else {
        _isAuthenticated = false;
        _errorMessage = 'Sign-in failed: Email or password incorrect';
      }
    } on DioException catch (e) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['details'] != null) {
        _errorMessage = errorResponse['details'][0]['issue'];
      } else {
        _errorMessage = 'Sign-in failed: An unknown error occurred';
      }
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> signUp(String username, String email, String password) async {
    try {
      final response = await _authRepository.signUp(username, email, password);
      if (response.statusCode == 200) {
        _isAuthenticated = true;
        _errorMessage = null;
      } else {
        _isAuthenticated = false;
        _errorMessage = 'Sign-up failed: Email or password incorrect';
      }
    } on DioException catch (e) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['details'] != null) {
        _errorMessage = errorResponse['details'][0]['issue'];
      } else {
        _errorMessage = 'Sign-up failed: An unknown error occurred';
      }
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      _isAuthenticated = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign-out failed: An unknown error occurred';
      notifyListeners();
    }
  }

  Future<void> getUserProfile() async {
    try {
      final response = await _authRepository.getUserProfile();
      if (response.statusCode == 200) {
        // Handle user profile data
      } else {
        _errorMessage = 'Failed to fetch user profile';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch user profile: An unknown error occurred';
    }
    notifyListeners();
  }
}
