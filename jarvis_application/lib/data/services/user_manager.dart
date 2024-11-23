// lib/data/services/user_manager.dart
import '../models/user.dart';
import 'auth_service.dart';

class UserManager {
  final AuthService _authService;

  UserManager(this._authService);

  Future<User?> getCurrentUser() async {
    try {
      final response = await _authService.getCurrentUser();
      if (response != null) {
        return User.fromJson(response);
      }
    } catch (e) {
      print('Failed to get current user: $e');
    }
    return null;
  }
}
