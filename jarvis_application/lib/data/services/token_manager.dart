import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_application/data/services/secure_storage_provider.dart';

final tokenManagerProvider = Provider<TokenManager>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return TokenManager(secureStorage);
});

class TokenManager {
  final FlutterSecureStorage _secureStorage;

  TokenManager(this._secureStorage);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _kbAccessTokenKey = 'kb_access_token';
  static const _kbRefreshTokenKey = 'kb_refresh_token';

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
    final accessKey = isKB ? _kbAccessTokenKey : _accessTokenKey;
    final refreshKey = isKB ? _kbRefreshTokenKey : _refreshTokenKey;

    if (accessToken != null) {
      await _secureStorage.write(key: accessKey, value: accessToken);
    }
    if (refreshToken != null) {
      await _secureStorage.write(key: refreshKey, value: refreshToken);
    }
  }

  Future<void> deleteTokens([bool isKB = false]) async {
    final accessKey = isKB ? _kbAccessTokenKey : _accessTokenKey;
    final refreshKey = isKB ? _kbRefreshTokenKey : _refreshTokenKey;

    await _secureStorage.delete(key: accessKey);
    await _secureStorage.delete(key: refreshKey);
  }

  Future<void> deleteAllTokens() async {
    await deleteTokens(false);
    await deleteTokens(true);
  }
}
