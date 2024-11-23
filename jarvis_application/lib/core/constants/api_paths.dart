import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPaths {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String signIn = '$baseUrl/api/v1/auth/sign-in';
  static final String signUp = '$baseUrl/api/v1/auth/sign-up';
  static final String getCurrentUser = '$baseUrl/api/v1/auth/current-user';
  static final String refreshTokens = '$baseUrl/api/v1/auth/refresh';
  static final String googleSignIn = '$baseUrl/api/v1/auth/google-sign-in';
}
