import 'chat_conversation.dart';
import 'chat_message.dart';

///AiChatMetadata
class AiChatMetadata {
  ChatConversation conversation;

  AiChatMetadata({
    required this.conversation,
  });

  factory AiChatMetadata.fromJson(Map<String, dynamic> json) => AiChatMetadata(
    conversation: ChatConversation.fromJson(json["conversation"]),
  );

  Map<String, dynamic> toJson() => {
    "conversation": conversation.toJson(),
  };

  factory AiChatMetadata.empty() => AiChatMetadata(
    conversation: ChatConversation.empty(),
  );

  // method thêm message vào conversation
  void addMessageToConversation(ChatMessage message) {
    conversation.addMessage(message);
  }

  void setConversationID(String conversationID) {
    conversation.id = conversationID;
  }

  void addMessage(ChatMessage currentMessage) {
    conversation.addMessage(currentMessage);
  }
}
