import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/prompt_service.dart';

final createPromptViewmodelProvider =
    StateNotifierProvider.autoDispose<PromptFormNotifier, PromptFormState>(
        (ref) {
  final promptService = ref.watch(promptServiceProvider);
  return PromptFormNotifier(promptService);
});

class PromptFormState {
  final String title;
  final String description;
  final String content;
  final bool isPublic;
  final String language;
  final String category;
  final String? error;

  PromptFormState({
    required this.title,
    required this.description,
    required this.content,
    required this.isPublic,
    required this.language,
    required this.category,
    this.error,
  });

  PromptFormState copyWith({
    String? title,
    String? description,
    String? content,
    bool? isPublic,
    String? language,
    String? category,
    String? error,
  }) {
    return PromptFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      isPublic: isPublic ?? this.isPublic,
      language: language ?? this.language,
      category: category ?? this.category,
      error: error ?? this.error,
    );
  }
}

class PromptFormNotifier extends StateNotifier<PromptFormState> {
  final PromptService _promptService;

  PromptFormNotifier(this._promptService)
      : super(PromptFormState(
          title: '',
          description: '',
          content: '',
          isPublic: false,
          language: 'English',
          category: 'OTHER',
        ));

  Future<void> createPrompt() async {
    try {
      await _promptService.createPrompt(
        category: state.isPublic ? state.category : 'OTHER',
        content: state.content,
        description: state.isPublic ? state.description : 'nothing',
        isPublic: state.isPublic,
        language: state.isPublic ? state.language : 'English',
        title: state.title,
      );

      state = PromptFormState(
        title: '',
        description: '',
        content: '',
        isPublic: false,
        language: 'English',
        category: 'OTHER',
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to create prompt: $e');
    }
  }

  bool isFormValid() {
    return state.title.isNotEmpty && state.content.isNotEmpty;
  }
}
