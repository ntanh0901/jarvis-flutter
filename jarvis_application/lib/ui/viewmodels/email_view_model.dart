import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/email/ai_email_metadata.dart';
import '../../data/models/email/ai_email_style_dto.dart';
import '../../data/models/email/request_ai_email.dart';
import '../../data/services/email_api.dart';

class ConversationMessage {
  final RequestAiEmail request; // Store the request
  final List<String> responses;
  final int currentResponseIndex;

  ConversationMessage({
    required this.request,
    required this.responses,
    this.currentResponseIndex = 0,
  });

  ConversationMessage copyWith({
    RequestAiEmail? request,
    List<String>? responses,
    int? currentResponseIndex,
  }) {
    return ConversationMessage(
      request: request ?? this.request,
      responses: responses ?? this.responses,
      currentResponseIndex: currentResponseIndex ?? this.currentResponseIndex,
    );
  }
}

class EmailViewModel extends StateNotifier<List<ConversationMessage>> {
  final EmailApi _emailApi;
  String? _selectedAction;
  String? get selectedAction => _selectedAction;
  final TextEditingController _inputController = TextEditingController();

  EmailViewModel(this._emailApi) : super([]);

  TextEditingController get inputController => _inputController;

  static const AiEmailMetadata _defaultMetadata = AiEmailMetadata(
    context: [],
    subject: 'Auto detect subject',
    sender: ' ',
    receiver: ' ',
    style: AiEmailStyleDto(
      length: 'normal',
      formality: 'same as received email',
      tone: 'same as received email',
    ),
    language: 'same as received email',
  );

  static const String _defaultAction =
      'Reply to this email, Auto detect sender and receiver, main idea to fill the response email';

  RequestAiEmail _createRequest({
    required String mainIdea,
    String? action,
    required String emailContent,
    AiEmailMetadata? metadata,
  }) {
    return RequestAiEmail(
      mainIdea: mainIdea,
      action: action ?? _defaultAction,
      email: emailContent,
      metadata: metadata ?? _defaultMetadata,
    );
  }

  void selectAction(String action) {
    if (_selectedAction == action) {
      _selectedAction = null;
    } else {
      _selectedAction = action;
    }
    state = [...state];
  }

  Future<void> sendEmail() async {
    final message = _inputController.text;
    if (message.isNotEmpty) {
      final request = _createRequest(
        mainIdea: ' ',
        action: _selectedAction != null ? _defaultAction : _defaultAction,
        emailContent: message,
      );

      // Add the user's request to the conversation history
      _addToConversationHistory(
        ConversationMessage(request: request, responses: []),
      );
      _inputController.clear();
      _selectedAction = null;

      try {
        final response = await _emailApi.sendEmail(request);

        final updatedConversation = [...state];
        final lastMessage = updatedConversation.last.copyWith(
          responses: [...updatedConversation.last.responses, response.email],
        );
        updatedConversation[updatedConversation.length - 1] = lastMessage;
        state = updatedConversation;
      } catch (e) {
        print('Error sending email: $e');
      }
    }
  }

  void refreshResponse(int index) async {
    if (index < 0 || index >= state.length) return;

    final currentRequest = state[index].request;
    try {
      final response = await _emailApi.sendEmail(currentRequest);
      final updatedResponses = [...state[index].responses, response.email];
      final updatedMessage = state[index].copyWith(responses: updatedResponses);

      final updatedState = [...state];
      updatedState[index] = updatedMessage;
      state = updatedState;
    } catch (e) {
      print('Error refreshing response: $e');
    }
  }

  bool canNavigateBack(int index) => state[index].currentResponseIndex > 0;

  bool canNavigateForward(int index) =>
      state[index].currentResponseIndex < state[index].responses.length - 1;

  void navigateResponse(int index, bool forward) {
    if (index < 0 || index >= state.length) return;

    final updatedMessage = state[index].copyWith(
      currentResponseIndex: forward
          ? state[index].currentResponseIndex + 1
          : state[index].currentResponseIndex - 1,
    );
    final updatedState = [...state];
    updatedState[index] = updatedMessage;
    state = updatedState;
  }

  void _addToConversationHistory(ConversationMessage message) {
    state = [...state, message];
  }
}

final emailViewModelProvider =
    StateNotifierProvider<EmailViewModel, List<ConversationMessage>>((ref) {
  final emailApi = ref.read(emailApiProvider);
  return EmailViewModel(emailApi);
});
final inputTextProvider = StateProvider<String>((ref) => '');
