import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../data/models/assistant.dart';
import '../../data/models/assistant_dto.dart';
import '../../data/models/email_models.dart';
import '../../data/services/email_api.dart';

enum RequestType { response, replyIdeas }

final requestTypeProvider = StateProvider<RequestType>((ref) {
  return RequestType.response;
});
final isFirstGenerationProvider = StateProvider<bool>((ref) => true);
final currentIndexProvider = StateProvider<int>((ref) => 0);
final generatedContentProvider = StateProvider<List<String>>((ref) => []);
final isLoadingProvider = StateProvider((ref) => false);

final emailStateProvider =
    StateNotifierProvider<EmailNotifier, EmailGenerationRequest>((ref) {
  final emailService = ref.read(emailApiProvider);
  return EmailNotifier(emailService);
});

class EmailNotifier extends StateNotifier<EmailGenerationRequest> {
  final EmailService _emailService;

  EmailNotifier(this._emailService)
      : super(EmailGenerationRequest(
          action: 'Reply to this email',
          email: '',
          mainIdea: '',
          metadata: AiEmailMetadata(
            context: [],
            language: '',
            receiver: '',
            sender: '',
            subject: '',
            style: AiEmailStyle(),
          ),
        ));

  void updateStyle({String? formality, String? length, String? tone}) {
    state = state.copyWith(
      metadata: state.metadata.copyWith(
        style: state.metadata.style.copyWith(
          formality: formality,
          length: length,
          tone: tone,
        ),
      ),
    );
  }

  void updateEmailContent({
    String? email,
    String? action,
  }) {
    state = state.copyWith(
      email: email,
      action: action,
    );
  }

  void updateLanguage(String language) {
    state = state.copyWith(
      metadata: state.metadata.copyWith(
        language: language,
      ),
    );
  }

  void updateAssistant(Id? id) {
    if (id == null) {
      state = state.copyWith(
        assistant: null,
      );
      return;
    }
    final selectedAssistant = Assistant.assistants.firstWhere(
      (assistant) => assistant.id == id,
    );

    state = state.copyWith(
      assistant: selectedAssistant.dto,
    );
  }

  Future<dynamic> generateEmail(RequestType type, WidgetRef ref) async {
    if (type == RequestType.replyIdeas) {
      state = state.copyWith(
        mainIdea: null,
        action: state.action.isEmpty ? 'Auto detect action' : null,
        metadata: state.metadata.copyWith(
          style: null,
        ),
      );
    } else {
      state = state.copyWith(
        action: 'Reply to this email',
        mainIdea: 'Auto detect main idea',
      );
    }

    final endpoint = type == RequestType.response
        ? ApiEndpoints.responseEmail
        : ApiEndpoints.suggestReplyIdeas;

    try {
      final response = await _emailService.generateEmail(state, endpoint);
      _updateGeneratedContent(ref, response, type);
    } catch (e) {
      rethrow;
    }
  }

  void _updateGeneratedContent(
      WidgetRef ref, dynamic response, RequestType type) {
    List<String> contents = [];

    if (type == RequestType.replyIdeas) {
      contents = response;
    } else {
      contents = [response];
    }

    ref.read(generatedContentProvider.notifier).state = contents;
    ref.read(currentIndexProvider.notifier).state = 0;
  }
}
