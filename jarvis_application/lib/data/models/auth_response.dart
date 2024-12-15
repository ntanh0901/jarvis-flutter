// models/auth_response.dart
class AuthResponse {
  final String accessToken;
  final String refreshToken;

  // getter
  String get getAccessToken => accessToken;

  String get getRefreshToken => refreshToken;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    return AuthResponse(
      accessToken: token['accessToken'],
      refreshToken: token['refreshToken'],
    );
  }
}
