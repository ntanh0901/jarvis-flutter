import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../viewmodels/create_prompt_viewmodel.dart';

class CreatePromptSheet extends ConsumerStatefulWidget {
  const CreatePromptSheet({super.key});

  @override
  ConsumerState<CreatePromptSheet> createState() => _CreatePromptSheetState();
}

class _CreatePromptSheetState extends ConsumerState<CreatePromptSheet> {
  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPromptViewmodelProvider.notifier);
    final promptState = ref.watch(createPromptViewmodelProvider);
    final height = MediaQuery.of(context).size.height * 0.9;

    return ScaffoldMessenger(
      key: rootScaffoldMessengerKey,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'New Prompt',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Radio<bool>(
                                        value: false,
                                        groupValue: promptState.isPublic,
                                        onChanged: (value) => viewModel.state =
                                            viewModel.state
                                                .copyWith(isPublic: value),
                                      ),
                                      const Text('Private Prompt'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<bool>(
                                        value: true,
                                        groupValue: promptState.isPublic,
                                        onChanged: (value) => viewModel.state =
                                            viewModel.state
                                                .copyWith(isPublic: value),
                                      ),
                                      const Text('Public Prompt'),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFDBE6FF),
                                      Color(0xFFF2DEFF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('🎉'),
                                    SizedBox(width: 8),
                                    Text(
                                      'Create a Prompt, Win Jarvis Pro',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              if (promptState.isPublic) ...[
                                const SizedBox(height: 16),
                                const Text(
                                  'Prompt Language',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildLanguageDropdown(ref),
                              ],
                              const SizedBox(height: 16),
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                hintText: 'Name of the prompt',
                                onChanged: (value) {
                                  viewModel.state =
                                      viewModel.state.copyWith(title: value);
                                },
                              ),
                              if (promptState.isPublic) ...[
                                const SizedBox(height: 16),
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildCategoryDropdown(ref),
                                const SizedBox(height: 16),
                                const Text(
                                  'Description (Optional)',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CustomTextField(
                                  hintText:
                                      'Describe your prompt so others can have a better understanding',
                                  maxLines: 2,
                                  onChanged: (value) {
                                    viewModel.state = viewModel.state
                                        .copyWith(description: value);
                                  },
                                ),
                              ],
                              const SizedBox(height: 16),
                              const Text(
                                'Prompt',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        const TextSpan(
                                            text: 'Use square brackets '),
                                        const TextSpan(
                                          text: '[ ]',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                            text: ' to specify user input. '),
                                        TextSpan(
                                          text: 'Learn More',
                                          style: const TextStyle(
                                            color: Color(0xFF7552EC),
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              print('Learn More clicked');
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                hintText:
                                    'e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]',
                                maxLines: 4,
                                onChanged: (value) {
                                  viewModel.state =
                                      viewModel.state.copyWith(content: value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            onPressed: () async {
                              if (viewModel.isFormValid()) {
                                await viewModel.createPrompt();
                                if (promptState.error == null) {
                                  Navigator.pop(context, true);
                                }
                              } else {
                                rootScaffoldMessengerKey.currentState
                                    ?.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please fill in all required fields.'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(WidgetRef ref) {
    final currentLanguage = ref.watch(createPromptViewmodelProvider).language;
    final supportedLanguages = languages;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: PopupMenuButton<String>(
          initialValue: currentLanguage,
          onSelected: (String language) {
            ref.read(createPromptViewmodelProvider.notifier).state =
                ref.read(createPromptViewmodelProvider.notifier).state.copyWith(
                      language: language != 'Auto' ? language : 'English',
                    );
          },
          itemBuilder: (BuildContext context) =>
              supportedLanguages.map((language) {
            final isSelected = language == currentLanguage;
            return PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: language,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFE8F4FE) : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      language.isNotEmpty ? language : 'Auto',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLanguage.isNotEmpty ? currentLanguage : 'Auto',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(WidgetRef ref) {
    final currentCategory = ref.watch(createPromptViewmodelProvider).category;
    final List<String> categories = [
      'other',
      'career',
      'business',
      'writing',
      'productivity',
      'coding',
      'marketing',
      'seo',
      'education',
      'chatbot',
      'fun',
    ];

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: PopupMenuButton<String>(
          initialValue: currentCategory,
          onSelected: (String category) {
            ref.read(createPromptViewmodelProvider.notifier).state =
                ref.read(createPromptViewmodelProvider.notifier).state.copyWith(
                      category: category != 'Auto' ? category : 'Other',
                    );
          },
          itemBuilder: (BuildContext context) => categories.map((category) {
            final isSelected = category == currentCategory;
            return PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              value: category,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFE8F4FE) : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      category.isNotEmpty ? category : 'Auto',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentCategory.isNotEmpty ? currentCategory : 'Auto',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
