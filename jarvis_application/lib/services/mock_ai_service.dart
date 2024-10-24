import 'dart:math';
import 'ai_service.dart';

class MockAIService implements AIService {
  final Random _random = Random();

  @override
  Future<String> generateResponse(List<Map<String, String>> conversationHistory) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Simulate AI response based on the conversation history

    List<String> responses = [
      "I see, can you tell me more about that?",
      "That's interesting, what else can you share?",
      "I understand, how would you like to proceed?",
    ];

    // Attach a random number to the response for uniqueness
    int randomNumber = _random.nextInt(1000);
    return "${responses[_random.nextInt(responses.length)]} (ID: $randomNumber)";
  }
}
