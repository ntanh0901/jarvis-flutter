/// KnowledgeResDto Model
class KnowledgeResDto {
  final DateTime createdAt;
  final String? createdBy;
  final String description;
  final String knowledgeName;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String userId;

  KnowledgeResDto({
    required this.createdAt,
    this.createdBy,
    required this.description,
    required this.knowledgeName,
    this.updatedAt,
    this.updatedBy,
    required this.userId,
  });

  KnowledgeResDto copyWith({
    DateTime? createdAt,
    String? createdBy,
    String? description,
    String? knowledgeName,
    DateTime? updatedAt,
    String? updatedBy,
    String? userId,
  }) {
    return KnowledgeResDto(
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      description: description ?? this.description,
      knowledgeName: knowledgeName ?? this.knowledgeName,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      userId: userId ?? this.userId,
    );
  }

  factory KnowledgeResDto.fromJson(Map<String, dynamic> json) {
    return KnowledgeResDto(
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      description: json['description'] ?? '',
      knowledgeName: json['knowledgeName'] ?? '',
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      updatedBy: json['updatedBy'],
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'description': description,
      'knowledgeName': knowledgeName,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'userId': userId,
    };
  }

  @override
  String toString() {
    return 'KnowledgeResDto{createdAt: $createdAt, createdBy: $createdBy, description: $description, knowledgeName: $knowledgeName, updatedAt: $updatedAt, updatedBy: $updatedBy, userId: $userId}';
  }
}

/// PageMetaDto Model
class PageMetaDto {
  final bool hasNext;
  final double limit;
  final double offset;
  final double total;

  PageMetaDto({
    required this.hasNext,
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory PageMetaDto.fromJson(Map<String, dynamic> json) {
    return PageMetaDto(
      hasNext: json['hasNext'],
      limit: json['limit'].toDouble(),
      offset: json['offset'].toDouble(),
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasNext': hasNext,
      'limit': limit,
      'offset': offset,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'PageMetaDto{hasNext: $hasNext, limit: $limit, offset: $offset, total: $total}';
  }
}

/// ApidogModel Model
class ApidogModel {
  final List<KnowledgeResDto> data;
  final PageMetaDto meta;

  ApidogModel({
    required this.data,
    required this.meta,
  });

  factory ApidogModel.fromJson(Map<String, dynamic> json) {
    return ApidogModel(
      data: (json['data'] as List)
          .map((item) => KnowledgeResDto.fromJson(item))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  String toString() {
    return 'ApidogModel{data: $data, meta: $meta}';
  }
}
