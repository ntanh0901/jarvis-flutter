import 'chat_conversation.dart';

class AiChatMetadata {
  final ChatConversation conversation;

  AiChatMetadata({required this.conversation});

  Map<String, dynamic> toJson() => {
    'conversation': conversation.toJson(),
  };

  factory AiChatMetadata.fromJson(Map<String, dynamic> json) {
    return AiChatMetadata(
      conversation: ChatConversation.fromJson(json['conversation']),
    );
  }
}
