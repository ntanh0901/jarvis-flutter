import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../services/mock_ai_service.dart';

class EmailComposeViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  String currentEmailResponse = '';
  String userInput = '';
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  // Use dynamic for values to allow different types, but ensure responses is List<String>
  List<Map<String, dynamic>> conversationHistory = [];

  final AIService aiService;

  EmailComposeViewModel({AIService? aiService})
      : aiService = aiService ?? MockAIService();

  Future<void> simulateAICall(String emailContent) async {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    notifyListeners();

    try {
      if (emailContent.isEmpty) {
        throw Exception("Email content is empty. Unable to generate response.");
      }

      // Add user input to the conversation history
      conversationHistory.add({
        'role': 'user',
        'content': emailContent,
        'responses': <String>[], // Initialize as a list of strings
        'currentResponseIndex': 0 // Store as an int
      });

      // Generate the first response
      final response = await aiService.generateResponse(
        conversationHistory.map((entry) {
          return {
            'role': entry['role']?.toString() ?? '',
            'content': entry['content']?.toString() ?? ''
          };
        }).toList(),
      );

      // Add AI response to the conversation history
      conversationHistory.add({
        'role': 'ai',
        'content': '',
        'responses': [response], // Add the response to the list
        'currentResponseIndex': 0
      });

      currentEmailResponse = response;
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
      currentEmailResponse = "Failed to generate response. Please try again.";
    } finally {
      isLoading = false;
      notifyListeners(); // Ensure this is called to update the UI
    }
  }

  void setUserInput(String input) {
    userInput = input;
    notifyListeners();
  }

  void reset() {
    emailController.clear();
    currentEmailResponse = '';
    userInput = '';
    hasError = false;
    errorMessage = '';
    conversationHistory.clear();
    notifyListeners();
  }

  void navigateResponse(int requestIndex, bool forward) {
    if (requestIndex < 0 || requestIndex >= conversationHistory.length) {
      return; // Ensure the requestIndex is within bounds
    }

    // Safely access the responses list and currentResponseIndex
    final responses =
        conversationHistory[requestIndex]['responses'] as List<String>? ?? [];
    int currentResponseIndex =
        conversationHistory[requestIndex]['currentResponseIndex'] as int? ?? 0;

    if (forward && currentResponseIndex < responses.length - 1) {
      currentResponseIndex++;
    } else if (!forward && currentResponseIndex > 0) {
      currentResponseIndex--;
    }

    // Update the currentResponseIndex in the conversationHistory
    conversationHistory[requestIndex]['currentResponseIndex'] =
        currentResponseIndex;

    // Update the currentEmailResponse to reflect the new response
    if (responses.isNotEmpty) {
      currentEmailResponse = responses[currentResponseIndex];
    }

    notifyListeners();
  }

  Future<void> refreshResponse(int requestIndex) async {
    try {
      if (requestIndex < 0 || requestIndex >= conversationHistory.length) {
        return;
      }

      // Create a new list of maps with only string values
      List<Map<String, String>> stringConversationHistory = conversationHistory.map((entry) {
        return {
          'role': entry['role']?.toString() ?? '',
          'content': entry['content']?.toString() ?? ''
        };
      }).toList();

      final newResponse = await aiService.generateResponse(stringConversationHistory);

      // Ensure responses is initialized
      final responses = conversationHistory[requestIndex]['responses'] as List<String>;
      responses.add(newResponse);
      conversationHistory[requestIndex]['currentResponseIndex'] = responses.length - 1;
      currentEmailResponse = newResponse;
      notifyListeners();
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
      notifyListeners();
    }
  }
}
