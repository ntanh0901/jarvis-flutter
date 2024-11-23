class ItemConversationRes {
  String? id;
  String? title;
  int? createdAt;

  ItemConversationRes(
      {this.id,
      this.title,
      this.createdAt,
 });

  ItemConversationRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['createdAt'] = createdAt;
    return data;
  }
}