import 'ai_chat_metadata.dart';
import 'assistant_dto.dart';
import 'chat_message.dart';

class RequestAiChat {
  final AssistantDto? assistant;
  final String content;
  final AiChatMetadata metadata;

  RequestAiChat({
    this.assistant,
    required this.content,
    required this.metadata,
  });

  RequestAiChat copyWith({
    AssistantDto? assistant,
    String? content,
    AiChatMetadata? metadata,
  }) {
    return RequestAiChat(
      assistant: assistant ?? this.assistant,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
    );
  }

  factory RequestAiChat.fromJson(Map<String, dynamic> json) {
    return RequestAiChat(
      assistant: json['assistant'] != null
          ? AssistantDto.fromJson(json['assistant'])
          : null,
      content: json['content'],
      metadata: AiChatMetadata.fromJson(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'content': content,
      'metadata': metadata.toJson(),
    };

    if (assistant != null) {
      json['assistant'] = assistant!.toJson();
    }

    return json;
  }

  Map<String, dynamic> toJsonFirstTime() {
    final Map<String, dynamic> json = {
      'content': content,
    };

    if (assistant != null) {
      json['assistant'] = assistant!.toJson();
    }

    return json;
  }
}
