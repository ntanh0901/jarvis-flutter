import 'chat_message.dart';

class ChatConversation {
  final String id;
  final List<ChatMessage> messages;

  ChatConversation({required this.id, required this.messages});

  Map<String, dynamic> toJson() => {
    'id': id,
    'messages': messages.map((message) => message.toJson()).toList(),
  };

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'],
      messages: (json['messages'] as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList(),
    );
  }
}
