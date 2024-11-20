import 'assistant_dto.dart';

///ChatMessage
class ChatMessage {
  AssistantDto? assistant;
  String content;
  String role;

  ChatMessage({
     this.assistant,
    required this.content,
    required this.role,
  });

  ChatMessage.empty()
      : assistant = null, content = "", role = "";


  void setValues({AssistantDto? newAssistant, String? newContent,String? newRole
  }) {
    if (newAssistant != null) {
      assistant = newAssistant;
    }
      content = newContent!=null?newContent:"";
    if (newRole != null) {
      role = newRole;
    }
  }



  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    assistant: AssistantDto.fromJson(json["assistant"]),
    content: json["content"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "assistant": assistant?.toJson(),
    "content": content,
    "role": role,
  };
}
