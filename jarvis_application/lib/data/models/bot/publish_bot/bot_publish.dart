


class BotPublish {
  final String createdAt;
  final String updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedAt;
  final String id;
  final String type;
  final String? accessToken;
  final Metadata metadata;
  final String assistantId;

  BotPublish({
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    required this.id,
    required this.type,
    this.accessToken,
    required this.metadata,
    required this.assistantId,
  });

  factory BotPublish.fromJson(Map<String, dynamic> json) {
    return BotPublish(
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'],
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      accessToken: json['accessToken'],
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
      assistantId: json['assistantId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (deletedAt != null) 'deletedAt': deletedAt,
      'id': id,
      'type': type,
      if (accessToken != null) 'accessToken': accessToken,
      'metadata': metadata.toJson(),
      'assistantId': assistantId,
    };
  }

  @override
  String toString() {
    return 'BotPublish{createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, deletedAt: $deletedAt, id: $id, type: $type, accessToken: $accessToken, metadata: $metadata, assistantId: $assistantId}';
  }
}

/// Metadata Model
class Metadata {
  final String botName;
  final String botToken;
  final String redirect;

  Metadata({
    required this.botName,
    required this.botToken,
    required this.redirect,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      botName: json['botName'] ?? '',
      botToken: json['botToken'] ?? '',
      redirect: json['redirect'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'botName': botName,
      'botToken': botToken,
      'redirect': redirect,
    };
  }

  @override
  String toString() {
    return 'Metadata{botName: $botName, botToken: $botToken, redirect: $redirect}';
  }
}
