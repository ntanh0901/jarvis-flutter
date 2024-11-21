import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../data/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  final ApiService _apiService = ApiService();

  Future<void> signIn(String email, String password) async {
    final response = await _apiService.post('/signin', {
      'email': email,
      'password': password,
    });

    if (response == 200) {
      // Handle successful sign-in
      final data = json.decode(response.body);
      _isAuthenticated = true;
      notifyListeners();
    } else {
      // Handle sign-in error
      throw Exception('Failed to sign in: ${response.body}');
    }
  }

  Future<void> checkAuthentication() async {
    // Check if the user is authenticated (e.g., check token validity)
    // For now, we'll just simulate a delay
    await Future.delayed(const Duration(seconds: 2));
    _isAuthenticated = false; // Set this based on actual authentication check
    notifyListeners();
  }

  void signOut() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
