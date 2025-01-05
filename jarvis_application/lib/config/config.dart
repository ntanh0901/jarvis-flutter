import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://api.jarvis.cx';
  static String get kbBaseUrl =>
      dotenv.env['KB_BASE_URL'] ?? 'https://knowledge-api.jarvis.cx';
}
