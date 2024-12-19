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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPromptViewmodelProvider.notifier);
    final promptState = ref.watch(createPromptViewmodelProvider);

    const normalBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 0.5,
      ),
    );

    const focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Center(
                      child: Text(
                        'New Prompt',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Public/Private Toggle
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<bool>(
                              activeColor: Colors.blue,
                              value: false,
                              groupValue: promptState.isPublic,
                              onChanged: (value) => viewModel.state =
                                  viewModel.state =
                                      viewModel.state.copyWith(isPublic: value),
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
                                  viewModel.state =
                                      viewModel.state.copyWith(isPublic: value),
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
                            'Create a Prompt, Win Monica Pro',
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
                      const Text('Prompt Language',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      IntrinsicWidth(
                        child: DropdownButtonFormField<String>(
                          value: promptState.language,
                          isExpanded:
                              true, // Ensures the dropdown expands fully
                          decoration: const InputDecoration(
                            enabledBorder: normalBorder,
                            focusedBorder: focusedBorder,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 0.0),
                          ),
                          items: languages.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            viewModel.state =
                                viewModel.state.copyWith(language: value!);
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Name Field
                    const Text('Name',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                      const Text('Category',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      IntrinsicWidth(
                        child: DropdownButtonFormField<String>(
                          value: promptState.category,
                          decoration: const InputDecoration(
                            enabledBorder: normalBorder,
                            focusedBorder: focusedBorder,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 0.0),
                          ),
                          items: categories.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            viewModel.state =
                                viewModel.state.copyWith(category: value!);
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Description (Optional)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText:
                            'Describe your prompt so others can have a better understanding',
                        maxLines: 2,
                        onChanged: (value) {
                          viewModel.state =
                              viewModel.state.copyWith(description: value);
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Prompt Field
                    const Text('Prompt',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                              const TextSpan(text: ' to specify user input. '),
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
                            await viewModel.createPrompt();
                            Navigator.pop(context);
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
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
    );
  }
}
