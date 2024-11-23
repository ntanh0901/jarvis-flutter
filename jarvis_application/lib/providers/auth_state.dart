import '../data/models/user.dart';

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? errorMessage;

  AuthState({this.isAuthenticated = false, this.user, this.errorMessage});

  AuthState copyWith(
      {bool? isAuthenticated, User? user, String? errorMessage}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
