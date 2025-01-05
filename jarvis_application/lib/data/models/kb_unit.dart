class Unit {
  final String id;
  final String name;
  final String type;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int size;
  final bool status;
  final String userId;
  final String knowledgeId;
  final List<String> openAiFileIds;
  final Map<String, dynamic> metadata;

  Unit({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.createdAt,
    this.updatedAt,
    required this.size,
    required this.status,
    required this.userId,
    required this.knowledgeId,
    required this.openAiFileIds,
    required this.metadata,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      size: json['size'],
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
      openAiFileIds: List<String>.from(json['openAiFileIds']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'size': size,
      'status': status,
      'userId': userId,
      'knowledgeId': knowledgeId,
      'openAiFileIds': openAiFileIds,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'Unit{id: $id, name: $name, type: $type, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, size: $size, status: $status, userId: $userId, knowledgeId: $knowledgeId, openAiFileIds: $openAiFileIds, metadata: $metadata}';
  }
}
