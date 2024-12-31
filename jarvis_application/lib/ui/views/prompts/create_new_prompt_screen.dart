import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/create_prompt_viewmodel.dart';

class CreateNewPrompt extends ConsumerStatefulWidget {
  const CreateNewPrompt({super.key});

  @override
  ConsumerState<CreateNewPrompt> createState() => _CreateNewPromptState();
}

class _CreateNewPromptState extends ConsumerState<CreateNewPrompt> {
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

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'New Prompt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 30),
                          // Public/Private Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Radio<bool>(
                                    activeColor: Colors.blue,
                                    value: false,
                                    groupValue: promptState.isPublic,
                                    onChanged: (value) => viewModel.state =
                                        viewModel.state = viewModel.state
                                            .copyWith(isPublic: value),
                                  ),
                                  const Text('Private Prompt'),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<bool>(
                                    activeColor: Colors.blue,
                                    value: true,
                                    groupValue: promptState.isPublic,
                                    onChanged: (value) => viewModel.state =
                                        viewModel.state = viewModel.state
                                            .copyWith(isPublic: value),
                                  ),
                                  const Text('Public Prompt'),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          // Banner
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFDBE6FF), Color(0xFFF2DEFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '🎉',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Create a Prompt, Win Jarvis Pro',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          // Show fields only if the prompt is public
                          if (promptState.isPublic) ...[
                            // Language Field
                            const Text(
                              'Prompt Language',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildLanguageDropdown(ref),
                          ],
                          const SizedBox(height: 16),
                          // Name Field
                          const Text(
                            'Name',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
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
                            // Category Field
                            const Text(
                              'Category',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildCategoryDropdown(ref),
                            const SizedBox(height: 16),
                            const Text(
                              'Description (Optional)',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
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
                          // Prompt Field
                          const Text(
                            'Prompt',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
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
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    const TextSpan(
                                        text: 'Use square brackets ',
                                        style: TextStyle(fontSize: 14)),
                                    const TextSpan(
                                        text: '[ ]',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                    const TextSpan(
                                        text: ' to specify user input. '),
                                    TextSpan(
                                      text: 'Learn More',
                                      style: const TextStyle(
                                        color: Color(0xFF7552EC),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
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
                          const SizedBox(height: 16),

                          // Cancel and Save Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Prompt created successfully!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please fill in all required fields.'),
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
                ),
              ],
            ),
            // Close Icon
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
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
          color: Colors.white,
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
          color: Colors.white,
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
