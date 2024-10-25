import 'package:flutter/material.dart';
import 'package:jarvis_application/models/ai_bot_model.dart';
import 'package:jarvis_application/services/ai_bot_service.dart';

class AIBotProvider with ChangeNotifier {
  List<AIBot> aiBots = [
    AIBot(
      id: '1',
      name: 'Assistant Alpha',
      description: 'An AI assistant specialized in scheduling tasks.',
      imageUrl: 'assets/images/bot_alpha.png', // Đường dẫn hình ảnh cho bot Alpha
      promptTemplate: 'Help me organize my tasks for today.',
      knowledgeBaseIds: [],
      isPublished: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    AIBot(
      id: '2',
      name: 'Assistant Beta',
      description: 'An AI bot focused on answering technical questions.',
      imageUrl: 'assets/images/bot_beta.png', // Đường dẫn hình ảnh cho bot Beta
      promptTemplate: 'Provide detailed answers for tech-related queries.',
      knowledgeBaseIds: [],
      isPublished: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Tạo AI Bot mới với hình ảnh
  Future<void> createAIBot(String name, String description, String imageUrl) async {
    AIBot newBot = AIBot(
      id: DateTime.now().toString(),
      name: name,
      description: description,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : 'assets/images/bot_alpha.png', // Nếu không có hình ảnh thì sử dụng ảnh mặc định
      promptTemplate: '',
      knowledgeBaseIds: [],
      isPublished: false,
      createdAt: DateTime.now(),
    );
    aiBots.add(newBot);
    notifyListeners();
  }

  // Xoá AI Bot
  Future<void> deleteAIBot(String botId) async {
    aiBots.removeWhere((bot) => bot.id == botId);
    notifyListeners();
  }
}
