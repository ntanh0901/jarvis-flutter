// lib/data/services/user_manager.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import 'auth_service.dart';

final userManagerProvider = Provider<UserManager>((ref) {
  final authService = ref.read(authServiceProvider);
  final secureStorageService = SecureStorageService();
  return UserManager(authService, secureStorageService);
});

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> saveUser(User user) async {
    try {
      await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final userString = await _secureStorage.read(key: 'user');
      if (userString != null) {
        final userJson = jsonDecode(userString);
        return User.fromJson(userJson);
      }
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
    return null;
  }

  Future<void> deleteUser() async {
    try {
      await _secureStorage.delete(key: 'user');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}

class UserManager {
  final AuthService _authService;
  final SecureStorageService _secureStorageService;

  UserManager(this._authService, this._secureStorageService);

  Future<User?> getCurrentUser() async {
    try {
      final response = await _authService.getCurrentUser();
      if (response != null) {
        final user = User.fromJson(response);
        await _secureStorageService.saveUser(user);
        return user;
      }
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
    return null;
  }

  Future<void> saveUser(User user) async {
    try {
      await _secureStorageService.saveUser(user);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  Future<void> deleteUser() async {
    try {
      await _secureStorageService.deleteUser();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
