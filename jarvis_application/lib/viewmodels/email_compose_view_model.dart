import 'package:flutter/material.dart';
import 'package:jarvis_application/services/ai_service.dart'; // Assume you have this service

class EmailComposeViewModel extends ChangeNotifier {
  final AIService _aiService;
  List<Map<String, dynamic>> conversationHistory = [];
  TextEditingController inputController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  EmailComposeViewModel(this._aiService);

  Future<void> refreshResponse(int index) async {
    if (index < 0 ||
        index >= conversationHistory.length ||
        conversationHistory[index]['role'] != 'ai') {
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final context = conversationHistory.sublist(0, index).map((e) => {
        'role': e['role'] as String,
        'content': e['content'] as String
      }).toList();

      final newResponse = await _aiService.generateResponse(context);

      conversationHistory[index] = {
        'role': 'ai',
        'content': newResponse,
        'responses': <String>[newResponse],
        'currentResponseIndex': 0
      };

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to refresh response: ${e.toString()}';
      notifyListeners();
    }
  }

  void sendMessage() async {
    if (inputController.text.isNotEmpty) {
      final userMessage = inputController.text;
      conversationHistory.add({
        'role': 'user',
        'content': userMessage,
      });
      inputController.clear();
      notifyListeners();

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      try {
        final context = conversationHistory.map((e) => {
          'role': e['role'] as String,
          'content': e['content'] as String
        }).toList();
        final aiResponse = await _aiService.generateResponse(context);
        conversationHistory.add({
          'role': 'ai',
          'content': aiResponse,
          'responses': <String>[aiResponse],
          'currentResponseIndex': 0
        });
        isLoading = false;
        notifyListeners();
      } catch (e) {
        isLoading = false;
        errorMessage = 'Failed to generate response: ${e.toString()}';
        notifyListeners();
      }
    }
  }

  void navigateResponse(int index, bool forward) {
    if (index < 0 ||
        index >= conversationHistory.length ||
        conversationHistory[index]['role'] != 'ai') {
      return;
    }

    final responses = conversationHistory[index]['responses'] as List<String>;
    var currentIndex = conversationHistory[index]['currentResponseIndex'] as int;

    if (forward && currentIndex < responses.length - 1) {
      currentIndex++;
    } else if (!forward && currentIndex > 0) {
      currentIndex--;
    } else {
      return; // No change, so we don't need to update
    }

    conversationHistory[index]['currentResponseIndex'] = currentIndex;
    conversationHistory[index]['content'] = responses[currentIndex];
    notifyListeners();
  }

  bool canNavigateBack(int index) {
    if (index < 0 || index >= conversationHistory.length || conversationHistory[index]['role'] != 'ai') {
      return false;
    }
    return (conversationHistory[index]['currentResponseIndex'] as int) > 0;
  }

  bool canNavigateForward(int index) {
    if (index < 0 || index >= conversationHistory.length || conversationHistory[index]['role'] != 'ai') {
      return false;
    }
    final responses = conversationHistory[index]['responses'] as List<String>;
    final currentIndex = conversationHistory[index]['currentResponseIndex'] as int;
    return currentIndex < responses.length - 1;
  }

  Future<void> generateQuickResponse(String action) async {
    if (conversationHistory.isEmpty) {
      errorMessage = 'No conversation context available.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final lastMessage = conversationHistory.last['content'] as String;

      final quickResponse = await _aiService.generateResponse([
        {'role': 'system', 'content': 'Generate a quick response for the action: $action'},
        {'role': 'user', 'content': lastMessage}
      ]);

      conversationHistory.add({
        'role': 'ai',
        'content': quickResponse,
        'responses': [quickResponse],
        'currentResponseIndex': 0
      });
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to generate quick response: ${e.toString()}';
      notifyListeners();
    }
  }
}
