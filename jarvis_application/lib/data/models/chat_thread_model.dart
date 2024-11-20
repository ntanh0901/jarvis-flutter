class ChatThread {
  String id;
  String userId;
  String botId;
  DateTime createdAt;
  List<ChatMessage> messages;

  ChatThread({
    required this.id,
    required this.userId,
    required this.botId,
    required this.createdAt,
    required this.messages,
  });
}

class ChatMessage {
  String id;
  String threadId;
  String sender;  // "user" hoặc "bot"
  String content;
  DateTime timestamp;
  int tokensUsed;

  ChatMessage({
    required this.id,
    required this.threadId,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.tokensUsed,
  });
}
