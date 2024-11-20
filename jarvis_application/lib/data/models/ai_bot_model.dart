class AIBot {
  final String id;
  final String name;
  final String description;
  final String imageUrl; // Thêm thuộc tính hình ảnh
  final String promptTemplate;
  final List<String> knowledgeBaseIds;
  final bool isPublished;
  final DateTime createdAt;

  AIBot({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl, // Thêm vào constructor
    required this.promptTemplate,
    required this.knowledgeBaseIds,
    required this.isPublished,
    required this.createdAt,
  });
}
