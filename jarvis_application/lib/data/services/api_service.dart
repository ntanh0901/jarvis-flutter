import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jarvis_application/config/config.dart';

class ApiService {
  final String baseUrl = Config.apiUrl;

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json, charset=UTF-8',
      },
      body: json.encode(data),
    );
    return response;
  }
}
