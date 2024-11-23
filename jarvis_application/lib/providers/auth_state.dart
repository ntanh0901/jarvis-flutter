import '../data/models/user.dart';

class AuthState {
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;
  final bool isAuthenticated;
  final User? user;

  AuthState({
    this.accessToken,
    this.refreshToken,
    this.errorMessage,
    this.isAuthenticated = false,
    this.user,
  });

  AuthState copyWith({
    String? accessToken,
    String? refreshToken,
    String? errorMessage,
    bool? isAuthenticated,
    User? user,
  }) {
    return AuthState(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }
}
