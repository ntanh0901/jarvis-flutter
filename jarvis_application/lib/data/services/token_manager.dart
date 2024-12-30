import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});

class TokenManager {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _kbAccessTokenKey = 'kb_access_token';
  static const String _kbRefreshTokenKey = 'kb_refresh_token';

  Future<String?> getAccessToken([bool isKB = false]) async {
    return await _secureStorage.read(
      key: isKB ? _kbAccessTokenKey : _accessTokenKey,
    );
  }

  Future<String?> getRefreshToken([bool isKB = false]) async {
    return await _secureStorage.read(
      key: isKB ? _kbRefreshTokenKey : _refreshTokenKey,
    );
  }

  Future<void> saveTokens({
    String? accessToken,
    String? refreshToken,
    bool isKB = false,
  }) async {
    try {
      final accessKey = isKB ? _kbAccessTokenKey : _accessTokenKey;
      final refreshKey = isKB ? _kbRefreshTokenKey : _refreshTokenKey;

      if (accessToken != null) {
        await _secureStorage.write(
          key: accessKey,
          value: accessToken,
        );
      }

      if (refreshToken != null) {
        await _secureStorage.write(
          key: refreshKey,
          value: refreshToken,
        );
      }
    } catch (e) {
      print('Error saving tokens: $e');
    }
  }

  Future<void> deleteTokens([bool isKB = false]) async {
    if (isKB) {
      await _secureStorage.delete(key: _kbAccessTokenKey);
      await _secureStorage.delete(key: _kbRefreshTokenKey);
    } else {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    }
  }

  Future<void> deleteAllTokens() async {
    await deleteTokens(false);
    await deleteTokens(true);
  }
}
