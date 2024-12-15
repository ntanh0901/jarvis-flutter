import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});

class TokenManager {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Define keys for access and refresh tokens
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Method to get the access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  // Method to save tokens securely
  // Save tokens securely
  Future<void> saveTokens(Map<String, dynamic> tokens,
      {bool isSaveRefreshToken = true}) async {
    try {
      // Store the access token
      await _secureStorage.write(
        key: _accessTokenKey,
        value: tokens['accessToken'],
      );

      // Store the refresh token
      if (isSaveRefreshToken) {
        await _secureStorage.write(
          key: _refreshTokenKey,
          value: tokens['refreshToken'],
        );
      }
    } catch (e) {
      print('Error saving tokens: $e');
    }
  }

  // Method to get the refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // Method to delete tokens securely (log out)
  Future<void> deleteTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
