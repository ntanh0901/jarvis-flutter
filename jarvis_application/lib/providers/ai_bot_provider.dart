import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../data/models/bot/ai_assistant.dart';

class AIAssistantProvider extends StateNotifier<List<AIAssistant>> {
  AIAssistantProvider() : super([]);

  final String baseUrl = 'https://knowledge-api.jarvis.cx';

  // Fetch assistants from API
  Future<void> fetchAIAssistants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImY4YzA4ZDNmLTIyMzEtNDE5Ni04ZTVmLTEzZDgwNjRlOWNkMSIsImVtYWlsIjoicXVhbmd0aGllbjEyMzRAZ21haWwuY29tIiwiaWF0IjoxNzM0NTg1MTI0LCJleHAiOjE3MzQ2NzE1MjR9.JUUws9trtonltGKekAnAN-1U3Z3PF8-qrT7pX3WsY_w', // Thay bằng token hợp lệ
        },
      );

      print('fetchAIAssistants Response Status: ${response.statusCode}');
      print('fetchAIAssistants Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List<dynamic>;
        state = data.map((json) => AIAssistant.fromJson(json)).toList();
      } else {
        print('Failed to fetch assistants: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching assistants: $e');
    }
  }


  // Create a new assistant
  Future<void> createAIAssistant(String name, String instructions, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Thay bằng token hợp lệ
        },
        body: jsonEncode({
          'assistantName': name,
          'instructions': instructions,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        fetchAIAssistants(); // Refresh the list
      } else {
        print('Failed to create assistant: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating assistant: $e');
    }
  }
}

final aiAssistantProvider = StateNotifierProvider<AIAssistantProvider, List<AIAssistant>>((ref) {
  return AIAssistantProvider();
});
