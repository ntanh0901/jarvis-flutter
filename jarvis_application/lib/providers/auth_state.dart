class AuthState {
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.accessToken,
    this.refreshToken,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith(
      {String? accessToken,
      String? refreshToken,
      String? errorMessage,
      bool? isAuthenticated}) {
    return AuthState(
      accessToken: accessToken,
      refreshToken: refreshToken,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
