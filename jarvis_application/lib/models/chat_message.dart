import 'assistant_dto.dart';

class ChatMessage {
  final String role;
  final String content;
  final AssistantDto assistant;
  final List<String> files;

  ChatMessage({
    required this.role,
    required this.content,
    required this.assistant,
    required this.files,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'assistant': assistant.toJson(),
    'files': files,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: json['content'],
      assistant: AssistantDto.fromJson(json['assistant']),
      files: List<String>.from(json['files'] ?? []),
    );
  }
}
