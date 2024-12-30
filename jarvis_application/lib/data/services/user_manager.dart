import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jarvis_application/data/services/secure_storage_provider.dart';

import '../models/user.dart';

final userManagerProvider = Provider<UserManager>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return UserManager(secureStorage);
});

class UserManager {
  final FlutterSecureStorage _secureStorage;

  UserManager(this._secureStorage);

  static const _userKey = 'user';

  Future<void> saveUser(User user) async {
    try {
      final userData = jsonEncode(user.toJson());
      await _secureStorage.write(key: _userKey, value: userData);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  Future<User?> getStoredUser() async {
    try {
      final userData = await _secureStorage.read(key: _userKey);
      if (userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get stored user: $e');
    }
  }

  Future<void> deleteUser() async {
    try {
      await _secureStorage.delete(key: _userKey);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
