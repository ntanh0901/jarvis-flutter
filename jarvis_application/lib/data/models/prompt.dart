class Prompt {
  final String id;
  final String? category;
  String content;
  final String createdAt;
  final String? description;
  bool? isFavorite;
  bool? isPublic;
  final String? language;
  String title;
  final String updatedAt;
  final String? userId;
  final String? userName;

  Prompt({
    required this.id,
    this.category,
    required this.content,
    required this.createdAt,
    this.description,
    this.isFavorite,
    this.isPublic,
    this.language,
    required this.title,
    required this.updatedAt,
    this.userId,
    this.userName,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['_id'],
      category: json['category'],
      content: json['content'],
      createdAt: json['createdAt'],
      description: json['description'],
      isFavorite: json['isFavorite'],
      isPublic: json['isPublic'],
      language: json['language'],
      title: json['title'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      userName: json['userName'],
    );
  }
}
