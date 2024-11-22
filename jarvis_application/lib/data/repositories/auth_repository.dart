// lib/repositories/auth_repository.dart
/*The AuthRepository provides an abstraction over the AuthService and handles the logic of interacting with the service.*/

import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  // Method to handle user sign-in
  Future<Map<String, dynamic>?> signIn(String email, String password) {
    return _authService.signIn(email, password);
  }

  // Method to handle user sign-up
  Future<Map<String, dynamic>?> signUp(
      String username, String email, String password) {
    return _authService.signUp(username, email, password);
  }

  // Method to refresh the access token using the refresh token
  Future<Map<String, dynamic>?> refreshTokens(String refreshToken) {
    return _authService.refreshTokens(refreshToken);
  }
}
