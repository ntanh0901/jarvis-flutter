import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/request_ai_email.dart';
import '../data/models/ai_email_metadata.dart';
import '../data/models/ai_email_style_dto.dart';
import '../data/services/email_api.dart';

final emailViewModelProvider = StateNotifierProvider<EmailViewModel, RequestAiEmail?>((ref) {
  final emailApi = ref.read(emailApiProvider);
  return EmailViewModel(emailApi);
});

class EmailViewModel extends StateNotifier<RequestAiEmail?> {
  final EmailApi _emailApi;

  EmailViewModel(this._emailApi) : super(null);

  void autoFillFields(String emailContent) {
    final metadata = AiEmailMetadata(
      context: [],
      subject: 'Auto-filled Subject',
      sender: 'Auto-filled Sender',
      receiver: 'Auto-filled Receiver',
      style: AiEmailStyleDto(
        length: 'long',
        formality: 'neutral',
        tone: 'friendly',
      ),
      language: 'vietnamese',
    );

    final request = RequestAiEmail(
      mainIdea: 'Auto-filled Main Idea',
      action: 'Reply to this email',
      email: emailContent,
      metadata: metadata,
    );

    state = request;
  }

  Future<void> sendEmail() async {
    if (state != null) {
      await _emailApi.sendEmail(state!);
    }
  }
}
