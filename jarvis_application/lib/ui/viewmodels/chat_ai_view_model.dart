import 'package:flutter/material.dart';
import '../models/assistant.dart';
import '../models/chat_message.dart';
import '../models/assistant_dto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatViewModel extends ChangeNotifier {
  String conversationId = '';
  List<ChatMessage> messages = [];
  Assistant? selectedAssistant;



  ChatViewModel() {
   // selectedAssistant = assistants.isNotEmpty ? assistants.first : null;
  }

  void changeAssistant(Assistant newAssistant) {
    selectedAssistant = newAssistant;
    notifyListeners();
  }

  Future<void> sendMessage(String content, String token) async {
    if (selectedAssistant == null || content.isEmpty) return;

    messages.add(ChatMessage(
      role: 'user',
      content: content,
      assistant: selectedAssistant!.dto,
      files: [],
    ));

    notifyListeners();

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'assistant': selectedAssistant!.dto.toJson(),
      'content': content,
      'metadata': {
        'conversation': {
          'id': conversationId.isNotEmpty ? conversationId : null,
          'messages': messages.map((message) => message.toJson()).toList(),
        },
      },
    });

    try {
      final response = await http.post(
        Uri.parse('/api/v1/ai-chat'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        conversationId = responseData['conversationId'];

        messages.add(ChatMessage(
          role: 'model',
          content: responseData['message'],
          assistant: selectedAssistant!.dto,
          files: [],
        ));
        notifyListeners();
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
