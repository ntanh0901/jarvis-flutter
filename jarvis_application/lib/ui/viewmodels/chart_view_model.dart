// lib/viewmodels/chat_view_model.dart
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final List<Map<String, String>> _messages = []; // Store user and AI messages
  final TextEditingController messageController = TextEditingController();

  List<Map<String, String>> get messages => _messages;

  void sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      _messages.add({'sender': 'user', 'message': message});
      notifyListeners();
      _simulateAiResponse(message); // Simulate AI response after sending
    }
    messageController.clear();
  }

  void _simulateAiResponse(String userMessage) {
    // Simulating AI's response - Replace with actual API call
    Future.delayed(const Duration(seconds: 1), () {
      String aiResponse =
          "AI Response to: $userMessage"; // Simulated AI response
      _messages.add({'sender': 'ai', 'message': aiResponse});
      notifyListeners();
    });
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
