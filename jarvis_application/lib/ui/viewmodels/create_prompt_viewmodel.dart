import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../views/prompts/api_prompts.dart';

final createPromptViewmodelProvider =
    StateNotifierProvider<PromptFormNotifier, PromptFormState>((ref) {
  return PromptFormNotifier();
});

class PromptFormState {
  final String title;
  final String description;
  final String content;
  final bool isPublic;
  final String language;
  final String category;

  PromptFormState({
    required this.title,
    required this.description,
    required this.content,
    required this.isPublic,
    required this.language,
    required this.category,
  });

  PromptFormState copyWith({
    String? title,
    String? description,
    String? content,
    bool? isPublic,
    String? language,
    String? category,
  }) {
    return PromptFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      isPublic: isPublic ?? this.isPublic,
      language: language ?? this.language,
      category: category ?? this.category,
    );
  }
}

class PromptFormNotifier extends StateNotifier<PromptFormState> {
  PromptFormNotifier()
      : super(PromptFormState(
          title: '',
          description: '',
          content: '',
          isPublic: false,
          language: 'English',
          category: 'other',
        ));

  Future<void> createPrompt() async {
    try {
      await ApiService.createPrompt(
        category: state.isPublic ? state.category : 'other',
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
          category: 'other');
    } catch (e) {
      // Handle error
      print('Failed to create prompt: $e');
    }
  }
}
