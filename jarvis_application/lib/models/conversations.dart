
class Conversations {
  String? cursor;
  int? limit;
  String assistantId;
  String assistantModel;

  Conversations({
     this.cursor ='',
     this.limit,
    required this.assistantId,
    required this.assistantModel,
  });

  void setCursor(String cursor) {
    this.cursor = cursor;
  }
  void setLimit(int limit) {
    this.limit = limit;
  }
  void setAssistantId(String assistantId) {
    this.assistantId = assistantId;
  }
  void setAssistantModel(String assistantModel) {
    this.assistantModel = assistantModel;
  }

  factory Conversations.fromJson(Map<String, dynamic> json) {
    return Conversations(
      cursor: json['cursor'],
      limit: json['limit'],
      assistantId: json['assistantId'],
      assistantModel: json['assistantModel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'limit': limit,
      'assistantId': assistantId,
      'assistantModel': assistantModel,
    };
  }

}