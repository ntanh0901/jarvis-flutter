import 'package:jarvis_application/data/models/bot/publish_bot/request/req_messenger_publish.dart';
import 'package:jarvis_application/data/models/bot/publish_bot/request/req_slack_publish.dart';
import 'package:jarvis_application/data/models/bot/publish_bot/request/req_telegram_publish.dart';


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
      metadata: Metadata.fromJson(json['type'], json['metadata'] ?? {}),
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
abstract class Metadata {
  const Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'telegram':
        return ReqTelegramPublish.fromJson(json) as Metadata;
      case 'slack':
        return ReqSlackPublish.fromJson(json) as Metadata;
      case 'messenger':
        return ReqMessengerPublish.fromJson(json) as Metadata;
      default:
        throw Exception('Unknown metadata type: $type');
    }
  }

  Map<String, dynamic> toJson();
}


// Example usage with polymorphism in Metadata
