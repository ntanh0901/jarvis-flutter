import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;
  String? _errorMessage;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _accessToken != null;

  // Sign-up method
  Future<bool> signUp(String username, String email, String password) async {
    try {
      final response = await _authRepository.signUp(username, email, password);

      if (response != null && response['user'] != null) {
        final success = await signIn(email, password);
        return success;
      } else {
        _errorMessage = 'Sign-up failed.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Sign-in method
  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _authRepository.signIn(email, password);

      if (response != null && response.containsKey('token')) {
        _accessToken = response['token']['accessToken'];
        _refreshToken = response['token']['refreshToken'];

        // Store tokens securely
        await _storage.write(key: 'accessToken', value: _accessToken);
        await _storage.write(key: 'refreshToken', value: _refreshToken);

        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Sign-in failed.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Refresh token method
  Future<bool> refreshTokens() async {
    try {
      final storedRefreshToken = await _storage.read(key: 'refreshToken');
      if (storedRefreshToken != null) {
        final response =
            await _authRepository.refreshTokens(storedRefreshToken);

        if (response != null && response.containsKey('token')) {
          _accessToken = response['token']['accessToken'];
          _refreshToken = response['token']['refreshToken'];

          await _storage.write(key: 'accessToken', value: _accessToken);
          await _storage.write(key: 'refreshToken', value: _refreshToken);

          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Failed to refresh token.';
          notifyListeners();
          return false;
        }
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString(); // Use the parsed error message
      notifyListeners();
      return false;
    }
  }

  // Clear tokens method
  Future<void> clearTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
}
