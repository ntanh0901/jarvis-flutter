import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../data/models/bot/ai_assistant.dart';
import '../data/models/bot/chat_bot/message.dart';

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

  // Cập nhật một trợ lý trong danh sách cục bộ
  void updateAssistantLocally({
    required String id,
    required String name,
    required String instructions,
    required String description,
  }) {
    state = state.map((assistant) {
      if (assistant.id == id) {
        return assistant.copyWith(
          assistantName: name,
          instructions: instructions,
          description: description,
        );
      }
      return assistant;
    }).toList();
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


  // delete assistant locally
  void removeAssistantById(String id) {
    state = state.where((assistant) => assistant.id != id).toList();
  }

// re-add assistant to the list if deletion fails
  void reAddAssistant({
    required String id,
    required String name,
    required String description,
    required String instructions,
    required String createdAt,
  }) {
    state = [
      ...state,
      AIAssistant(
        id: id,
        assistantName: name,
        description: description,
        instructions: instructions,
        createdAt: createdAt,
        openAiAssistantId: '',
        openAiThreadIdPlay: '',
      ),
    ];
  }




  // Fetch a single assistant by ID
  Future<AIAssistant?> fetchAssistantById(String assistantId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant/$assistantId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AIAssistant.fromJson(data);
      } else {
        print('Failed to fetch assistant: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching assistant by ID: $e');
      return null;
    }
  }



// Fetch messages of a thread by openAiThreadId
  Future<List<Message>> fetchMessagesByThreadId(String openAiThreadId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant/thread/$openAiThreadId/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        print('Failed to fetch messages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching messages by thread ID: $e');
      return [];
    }
  }


  // Send a message to an assistant
  Future<String> sendMessageToAssistant(
      String assistantId, String message, String openAiThreadId) async {
    try {
      print('Ai bot hereeeeee1');

      final response = await http.post(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant/$assistantId/ask'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode({
          'message': message,
          'openAiThreadId': openAiThreadId,
          'additionalInstruction': '',
        }),
      );
      print('Ai bot hereeeeee2');
      print('Response status hereeeeee3: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response body at ai botttttttttttttt: ${response.body}');

        try {
          // if it's JSON, return the JSON object
          final data = jsonDecode(response.body);
          print('Response body at ai botttttttttttttt2: $data');
          return data.toString();
        } catch (e) {
          // if it's the raw String
          print('Response is not JSON - raw String: ${response.body}');
          return response.body;
        }
      } else {
        print('Failed to send message: ${response.statusCode}');
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error sending message: $e');
      return 'Error: $e';
    }
  }


  Future<void> addKnowledgeToAssistant({
    required String assistantId,
    required String knowledgeId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        print('Successfully linked knowledge $knowledgeId to assistant $assistantId');
        print('Response body: ${response.body}');
      } else {
        throw Exception(
            'Failed to link knowledge. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error linking knowledge to assistant: $e');
      rethrow; // Nếu cần để xử lý lỗi ở UI
    }
  }


}





final aiAssistantProvider = StateNotifierProvider<AIAssistantProvider, List<AIAssistant>>((ref) {
  return AIAssistantProvider();
});
