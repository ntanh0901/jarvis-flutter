import 'package:flutter/material.dart';

import '../data/models/chat_thread_model.dart';
import '../data/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<ChatThread> chatThreads = [];
  List<ChatMessage> currentMessages = [];

  // Lấy danh sách thread chat
  Future<void> fetchChatThreads(String userId) async {
    chatThreads = (await _chatService.getChatThreads(userId))!;
    notifyListeners();
  }

  // Tạo thread chat mới
  Future<void> createChatThread(String userId, String botId) async {
    ChatThread? newThread = await _chatService.createChatThread(userId, botId);
    chatThreads.add(newThread!);
    notifyListeners();
  }

  // Lấy lịch sử chat của thread cụ thể
  Future<void> fetchChatHistory(String threadId) async {
    currentMessages = (await _chatService.getChatHistory(threadId))!;
    notifyListeners();
  }

  // Gửi tin nhắn và nhận phản hồi từ AI Bot
  Future<void> sendMessage(String threadId, String message) async {
    ChatMessage? newMessage = await _chatService.sendMessage(threadId, message);
    currentMessages.add(newMessage!);
    notifyListeners();
  }
}
