class ConversationHistoryParams{
  String conversationId;

  ConversationHistoryParams({
    required this.conversationId,
  });

  factory ConversationHistoryParams.fromJson(Map<String, dynamic> json) => ConversationHistoryParams(
    conversationId: json["conversationId"],
  );

  Map<String, dynamic> toJson() => {
    "conversationId": conversationId,
  };
}