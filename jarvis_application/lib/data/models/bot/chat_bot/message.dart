import 'dart:convert';

class Message {
  final String role;
  final int createdAt;
  final List<Content> content;

  Message({
    required this.role,
    required this.createdAt,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      createdAt: json['createdAt'],
      content: (json['content'] as List)
          .map((item) => Content.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'createdAt': createdAt,
      'content': content.map((item) => item.toJson()).toList(),
    };
  }
}

class Content {
  final String type;
  final TextContent text;

  Content({
    required this.type,
    required this.text,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      type: json['type'],
      text: TextContent.fromJson(json['text']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text.toJson(),
    };
  }
}

class TextContent {
  final String value;
  final List<dynamic> annotations;

  TextContent({
    required this.value,
    required this.annotations,
  });

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(
      value: json['value'],
      annotations: json['annotations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'annotations': annotations,
    };
  }
}

// Example usage
// void main() {
//   String jsonString = '[{"role":"assistant","createdAt":1734747468,"content":[{"type":"text","text":{"value":"Hello!","annotations":[]}}]}]';
//
//   List<Message> list = (jsonDecode(jsonString) as List)
//       .map((json) => Message.fromJson(json))
//       .toList();
//
//   print(list[0].role);
//   print(jsonEncode(list));
// }
