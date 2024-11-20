import 'ai_chat_metadata.dart';
import 'assistant_dto.dart';
import 'chat_message.dart';

// request to create a chat message
class RequestAiChat {
  AssistantDto assistant;
  String content;
  AiChatMetadata metadata;

  RequestAiChat({
    required this.assistant,
    required this.content,
    required this.metadata,
  });

  void addConversationID(String conversationID) {
    metadata.conversation.id = conversationID;
  }

  void addMessage(ChatMessage message) {
    this.content = message.content;
    this.assistant= message.assistant!;
    this.metadata.addMessageToConversation(message);
  }

  factory RequestAiChat.fromJson(Map<String, dynamic> json) {
    return RequestAiChat(
      assistant: AssistantDto.fromJson(json['assistant']),
      content: json['content'],
      metadata: AiChatMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assistant': assistant.toJson(),
      'content': content,
      'metadata': metadata.toJson(),
    };
  }

}
