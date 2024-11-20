import 'assistant_dto.dart';

///ChatMessage
class ChatMessage {
  AssistantDto? assistant;
  String content;
  List<String>? files; // Cho phép nullable
  String role;

  ChatMessage({
     this.assistant,
    required this.content,
    this.files, // Không required, có thể là null
    required this.role,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    assistant: AssistantDto.fromJson(json["assistant"]),
    content: json["content"],
    files: json["files"] != null // Kiểm tra nếu không null
        ? List<String>.from(json["files"].map((x) => x))
        : null,
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "assistant": assistant?.toJson(),
    "content": content,
    "files": files != null
        ? List<dynamic>.from(files!.map((x) => x))
        : null,
    "role": role,
  };
}
