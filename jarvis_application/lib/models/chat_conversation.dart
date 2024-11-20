import 'chat_message.dart';

///ChatConversation
class ChatConversation {
  String? id; // Nullable id
  List<ChatMessage> messages;

  ChatConversation({
    this.id,
    required this.messages,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) => ChatConversation(
    id: json["id"],
    messages: List<ChatMessage>.from(
        json["messages"].map((x) => ChatMessage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
  };

  // method khởi tạo rỗng
  factory ChatConversation.empty() => ChatConversation(
    id: null, // Không có ID
    messages: [], // Danh sách tin nhắn rỗng
  );


  // method để thêm message zô
  void addMessage(ChatMessage message){
    messages.add(message);
  }
}
