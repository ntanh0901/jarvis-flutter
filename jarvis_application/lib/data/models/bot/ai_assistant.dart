/// AssistantResponse Model
class AIAssistant {
  final String createdAt;
  final String id;
  final String assistantName;
  final String openAiAssistantId;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String instructions;
  final String description;
  final String? openAiThreadIdPlay;

  AIAssistant({
    required this.createdAt,
    required this.id,
    required this.assistantName,
    required this.openAiAssistantId,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    required this.instructions,
    required this.description,
    this.openAiThreadIdPlay,
  });

  factory AIAssistant.fromJson(Map<String, dynamic> json) {
    return AIAssistant(
      createdAt: json['createdAt'] ?? '',
      id: json['id'] ?? '',
      assistantName: json['assistantName'] ?? '',
      openAiAssistantId: json['openAiAssistantId'] ?? '',
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      instructions: json['instructions'] ?? '',
      description: json['description'] ?? '',
      openAiThreadIdPlay: json['openAiThreadIdPlay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'id': id,
      'assistantName': assistantName,
      'openAiAssistantId': openAiAssistantId,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (instructions != null) 'instructions': instructions,
      if (description != null) 'description': description,
      if (openAiThreadIdPlay != null) 'openAiThreadIdPlay': openAiThreadIdPlay,
    };
  }

  @override
  String toString() {
    return 'AssistantResponse{createdAt: $createdAt, id: $id, assistantName: $assistantName, openAiAssistantId: $openAiAssistantId, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, instructions: $instructions, description: $description, openAiThreadIdPlay: $openAiThreadIdPlay}';
  }
}
