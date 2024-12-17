/// CreateAssistantRequest Model
class CreateAssistantRequest {
  final String assistantName;
  final String instructions;
  final String description;

  CreateAssistantRequest({
    required this.assistantName,
    required this.instructions,
    required this.description,
  });

  factory CreateAssistantRequest.fromJson(Map<String, dynamic> json) {
    return CreateAssistantRequest(
      assistantName: json['assistantName'] ?? '',
      instructions: json['instructions'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assistantName': assistantName,
      'instructions': instructions,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'CreateAssistantRequest{assistantName: $assistantName, instructions: $instructions, description: $description}';
  }
}
