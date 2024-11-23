
class ItemConversationHistoryRes{
  String? answer;
  int? createdAt;
  List<String>? files;
  String? query;

  ItemConversationHistoryRes({
    this.answer,
    this.createdAt,
    this.files,
    this.query,
  });


  ItemConversationHistoryRes.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    createdAt = json['createdAt'];
    files = List<String>.from(json['files']);
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer'] = answer;
    data['createdAt'] = createdAt;
    data['files'] = files;
    data['query'] = query;
    return data;
  }
}