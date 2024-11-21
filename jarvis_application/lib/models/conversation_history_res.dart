import 'item_conversation_history_res.dart';

class ConversationHistoryRes{
  String cursor;
  bool hasMore;
  int limit;
  List<ItemConversationHistoryRes>? items;

  ConversationHistoryRes({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    this.items =const [],
  });

  ConversationHistoryRes.fromJson(Map<String, dynamic> json)
      : cursor = json['cursor'],
        hasMore = json['hasMore'],
        limit = json['limit'],
        items = List<ItemConversationHistoryRes>.from(json['items'].map((x) => ItemConversationHistoryRes.fromJson(x)));

  Map<String, dynamic> toJson() => {
    'cursor': cursor,
    'hasMore': hasMore,
    'limit': limit,
    'items': List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}