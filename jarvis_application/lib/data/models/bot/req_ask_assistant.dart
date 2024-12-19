/// AskAssistantRequest Model
class RequestAskAssistant {
  final String message;
  final String openAiThreadId;
  final String additionalInstruction;

  RequestAskAssistant({
    required this.message,
    required this.openAiThreadId,
    this.additionalInstruction = '',
  });

  factory RequestAskAssistant.fromJson(Map<String, dynamic> json) {
    return RequestAskAssistant(
      message: json['message'] ?? '',
      openAiThreadId: json['openAiThreadId'] ?? '',
      additionalInstruction: json['additionalInstruction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'openAiThreadId': openAiThreadId,
      'additionalInstruction': additionalInstruction,
    };
  }

  @override
  String toString() {
    return 'RequestAskAssistant{message: $message, openAiThreadId: $openAiThreadId, additionalInstruction: $additionalInstruction}';
  }
}
