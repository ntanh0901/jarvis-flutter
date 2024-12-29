import 'assistant_dto.dart';

class EmailContent {
  final String content;
  final String receiver;
  final String sender;
  final String subject;

  EmailContent({
    required this.content,
    required this.receiver,
    required this.sender,
    required this.subject,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'receiver': receiver,
        'sender': sender,
        'subject': subject,
      };
}

class AiEmailStyle {
  final String formality;
  final String length;
  final String tone;

  AiEmailStyle({
    required this.formality,
    required this.length,
    required this.tone,
  });

  AiEmailStyle copyWith({
    String? formality,
    String? length,
    String? tone,
  }) {
    return AiEmailStyle(
      formality: formality ?? this.formality,
      length: length ?? this.length,
      tone: tone ?? this.tone,
    );
  }

  Map<String, dynamic> toJson() => {
        'formality': formality,
        'length': length,
        'tone': tone,
      };
}

class AiEmailMetadata {
  final List<EmailContent> context;
  final String language;
  final String receiver;
  final String sender;
  final AiEmailStyle? style;
  final String subject;

  AiEmailMetadata({
    required this.context,
    required this.language,
    required this.receiver,
    required this.sender,
    this.style,
    required this.subject,
  });

  AiEmailMetadata copyWith({
    List<EmailContent>? context,
    String? language,
    String? receiver,
    String? sender,
    AiEmailStyle? style,
    String? subject,
  }) {
    return AiEmailMetadata(
      context: context ?? this.context,
      language: language ?? this.language,
      receiver: receiver ?? this.receiver,
      sender: sender ?? this.sender,
      style: style ?? this.style,
      subject: subject ?? this.subject,
    );
  }

  Map<String, dynamic> toJson() => {
        'context': context.map((e) => e.toJson()).toList(),
        'language': language,
        'receiver': receiver,
        'sender': sender,
        'style': style?.toJson(),
        'subject': subject,
      };
}

class EmailGenerationRequest {
  final String action;
  final AssistantDto? assistant;
  final String email;
  final String mainIdea;
  final AiEmailMetadata metadata;

  EmailGenerationRequest({
    required this.action,
    this.assistant,
    required this.email,
    required this.mainIdea,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'action': action,
        'assistant': assistant?.toJson(),
        'email': email,
        'mainIdea': mainIdea,
        'metadata': metadata.toJson(),
      };

  EmailGenerationRequest copyWith({
    AssistantDto? assistant,
    String? action,
    String? email,
    String? mainIdea,
    AiEmailMetadata? metadata,
  }) {
    return EmailGenerationRequest(
      assistant: assistant ?? this.assistant,
      action: action ?? this.action,
      email: email ?? this.email,
      mainIdea: mainIdea ?? this.mainIdea,
      metadata: metadata ?? this.metadata,
    );
  }
}
