import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/bot/ai_assistant.dart';
import '../data/models/bot/chat_bot/message.dart';
import 'dio_provider.dart';

class AIAssistantProvider extends StateNotifier<List<AIAssistant>> {
  AIAssistantProvider(this._dioKB) : super([]);

  final DioKB _dioKB;

  // Fetch assistants from API
  Future<void> fetchAIAssistants() async {
    try {
      final response = await _dioKB.dio.get('/kb-core/v1/ai-assistant');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        state = data
            .map((json) => AIAssistant.fromJson(json))
            .toList()
            .reversed
            .toList();
      }
    } catch (e) {
      print('Error fetching assistants: $e');
    }
  }

  // Create a new assistant
  Future<void> createAIAssistant(
      String name, String instructions, String description) async {
    try {
      final response = await _dioKB.dio.post(
        '/kb-core/v1/ai-assistant',
        data: {
          'assistantName': name,
          'instructions': instructions,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        await fetchAIAssistants();
      }
    } catch (e) {
      print('Error creating assistant: $e');
      rethrow;
    }
  }

  // Update assistant
  Future<void> updateAIAssistant({
    required String id,
    required String name,
    required String instructions,
    required String description,
  }) async {
    try {
      final response = await _dioKB.dio.patch(
        '/kb-core/v1/ai-assistant/$id',
        data: {
          'assistantName': name,
          'instructions': instructions,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        await fetchAIAssistants();
      }
    } catch (e) {
      print('Error updating assistant: $e');
      rethrow;
    }
  }

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

  // Delete assistant
  Future<void> deleteAIAssistant(String assistantId) async {
    try {
      final response =
          await _dioKB.dio.delete('/kb-core/v1/ai-assistant/$assistantId');

      if (response.statusCode == 200) {
        removeAssistantById(assistantId);
      }
    } catch (e) {
      print('Error deleting assistant: $e');
      rethrow;
    }
  }

  // Local state management methods
  void removeAssistantById(String id) {
    state = state.where((assistant) => assistant.id != id).toList();
  }

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

  // Fetch single assistant
  Future<AIAssistant?> fetchAssistantById(String assistantId) async {
    try {
      final response =
          await _dioKB.dio.get('/kb-core/v1/ai-assistant/$assistantId');

      if (response.statusCode == 200) {
        return AIAssistant.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching assistant by ID: $e');
      return null;
    }
  }

  // Fetch messages
  Future<List<Message>> fetchMessagesByThreadId(String openAiThreadId) async {
    try {
      final response = await _dioKB.dio
          .get('/kb-core/v1/ai-assistant/thread/$openAiThreadId/messages');

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => Message.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching messages by thread ID: $e');
      return [];
    }
  }

  // Send message
  Future<String> sendMessageToAssistant(
      String assistantId, String message, String openAiThreadId) async {
    try {
      final response = await _dioKB.dio.post(
        '/kb-core/v1/ai-assistant/$assistantId/ask',
        data: {
          'message': message,
          'openAiThreadId': openAiThreadId,
          'additionalInstruction': '',
        },
      );

      if (response.statusCode == 200) {
        return response.data.toString();
      }
      return 'Error: ${response.statusCode}';
    } catch (e) {
      print('Error sending message: $e');
      return 'Error: $e';
    }
  }

  // Add knowledge to assistant
  Future<void> addKnowledgeToAssistant({
    required String assistantId,
    required String knowledgeId,
  }) async {
    try {
      final response = await _dioKB.dio.post(
          '/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to link knowledge. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error linking knowledge to assistant: $e');
      rethrow;
    }
  }

  Future<void> removeKnowledgeFromAssistant({
    required String assistantId,
    required String knowledgeId,
  }) async {
    try {
      final response = await _dioKB.dio.delete(
          '/kb-core/v1/ai-assistant/$assistantId/knowledges/$knowledgeId');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to unlink knowledge. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error unlinking knowledge from assistant: $e');
      rethrow;
    }
  }

  Future<List<String>> getImportedKnowledgeByAssistantId(
      String assistantId) async {
    try {
      final response = await _dioKB.dio.get(
        '/kb-core/v1/ai-assistant/$assistantId/knowledges',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((item) => item['id'] as String).toList();
      } else {
        throw Exception(
          'Failed to fetch imported knowledge. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching imported knowledge: $e');
      rethrow;
    }
  }
}

final aiAssistantProvider =
    StateNotifierProvider<AIAssistantProvider, List<AIAssistant>>((ref) {
  final dioKB = ref.read(dioKBProvider);
  return AIAssistantProvider(dioKB);
});
