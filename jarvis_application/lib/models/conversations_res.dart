import 'package:jarvis_application/models/item_conversation_res.dart';

class ConversationsRes{
  String cursor;
  bool has_more;
  int limit;
  List<ItemConversationRes> items;

  ConversationsRes({
    required this.cursor,
    required this.has_more,
    required this.limit,
    required this.items,
  });

  ConversationsRes.fromJson(Map<String, dynamic> json)
      : cursor = json['cursor'],
        has_more = json['has_more'],
        limit = json['limit'],
        items = List<ItemConversationRes>.from(json['items'].map((x) => ItemConversationRes.fromJson(x)));

  Map<String, dynamic> toJson() => {
    'cursor': cursor,
    'hasMore': has_more,
    'limit': limit,
    'items': List<dynamic>.from(items.map((x) => x.toJson())),
  };
}