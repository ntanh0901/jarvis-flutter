import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/assistant.dart';
import '../../data/models/assistant_dto.dart';
import '../../data/models/email_models.dart';

enum RequestType { response, replyIdeas }

final requestTypeProvider = StateProvider<RequestType>((ref) {
  return RequestType.response;
});

final emailStateProvider =
    StateNotifierProvider<EmailNotifier, EmailGenerationRequest>((ref) {
  return EmailNotifier();
});

class EmailNotifier extends StateNotifier<EmailGenerationRequest> {
  EmailNotifier()
      : super(EmailGenerationRequest(
          assistant: null,
          action: 'write',
          email: '',
          mainIdea: '',
          metadata: AiEmailMetadata(
            context: [],
            language: 'Auto',
            receiver: '',
            sender: '',
            style: AiEmailStyle(
              formality: 'Auto',
              length: 'Auto',
              tone: 'Auto',
            ),
            subject: '',
          ),
        ));

  void updateStyle({String? formality, String? length, String? tone}) {
    state = state.copyWith(
      metadata: state.metadata.copyWith(
        style: state.metadata.style?.copyWith(
          formality: formality,
          length: length,
          tone: tone,
        ),
      ),
    );
  }

  void updateEmailContent({
    String? receiver,
    String? sender,
    String? subject,
    String? mainIdea,
  }) {
    state = state.copyWith(
      mainIdea: mainIdea,
      metadata: state.metadata.copyWith(
        receiver: receiver,
        sender: sender,
        subject: subject,
      ),
    );
  }

  void updateLanguage(String language) {
    state = state.copyWith(
      metadata: state.metadata.copyWith(
        language: language,
      ),
    );
  }

  void updateAssistant(Id id) {
    final selectedAssistant = Assistant.assistants.firstWhere(
      (assistant) => assistant.id == id,
    );

    // Update the state with the new assistant
    state = state.copyWith(
      assistant: selectedAssistant.dto,
    );
  }
}
