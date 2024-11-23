import 'item_conversation_history_res.dart';

class ConversationHistoryRes{
  String cursor;
  bool has_more;
  int limit;
  List<ItemConversationHistoryRes>? items;

  ConversationHistoryRes({
    required this.cursor,
    required this.has_more,
    required this.limit,
    this.items =const [],
  });

  ConversationHistoryRes.fromJson(Map<String, dynamic> json)
      : cursor = json['cursor'],
        has_more = json['has_more'],
        limit = json['limit'],
        items = List<ItemConversationHistoryRes>.from(json['items'].map((x) => ItemConversationHistoryRes.fromJson(x)));

  Map<String, dynamic> toJson() => {
    'cursor': cursor,
    'has_more': has_more,
    'limit': limit,
    'items': List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}