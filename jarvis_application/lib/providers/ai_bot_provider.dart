import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../data/models/bot/ai_assistant.dart';

class AIAssistantProvider extends StateNotifier<List<AIAssistant>> {
  AIAssistantProvider() : super([]);

  final String baseUrl = 'https://knowledge-api.jarvis.cx';
  final String apiToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImY4YzA4ZDNmLTIyMzEtNDE5Ni04ZTVmLTEzZDgwNjRlOWNkMSIsImVtYWlsIjoicXVhbmd0aGllbjEyMzRAZ21haWwuY29tIiwiaWF0IjoxNzM0NzE4NDUxLCJleHAiOjE3MzQ4MDQ4NTF9.m0WdnE1jK6Mj0PTwz5p2b4DDAvsDjpYRqSsPFSzriQ4';


  // Fetch assistants from API
  Future<void> fetchAIAssistants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      print('fetchAIAssistants Response Statusssssssssss: ${response.statusCode}');
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
          'Authorization': 'Bearer $apiToken', // Thay bằng token hợp lệ
        },
        body: jsonEncode({
          'assistantName': name,
          'instructions': instructions,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        await fetchAIAssistants(); // Refresh the list
      } else {
        print('Failed to create assistant: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating assistant: $e');
    }
  }


  // Hàm update assistant
  Future<void> updateAIAssistant({
    required String id,
    required String name,
    required String instructions,
    required String description,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode({
          'assistantName': name,
          'instructions': instructions,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        print('Assistant updated successfully');
        await fetchAIAssistants();
      } else {
        throw Exception('Failed to update assistant');
      }
    } catch (e) {
      print('Error updating assistant: $e');
      rethrow;
    }
  }


  // Hàm xóa assistant
  Future<void> deleteAIAssistant(String assistantId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant/$assistantId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if(response.statusCode == 200) {
        state = state.where((assistant) => assistant.id != assistantId).toList();
      } else {
        throw Exception('Failed to delete assistant');
      }

    } catch (e) {
      print('Error deleting assistant: $e');
      rethrow;
    }
  }


}

final aiAssistantProvider = StateNotifierProvider<AIAssistantProvider, List<AIAssistant>>((ref) {
  return AIAssistantProvider();
});
