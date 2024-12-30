// lib/views/writing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/widgets/app_drawer.dart';

import '../../../data/models/assistant.dart';
import '../../../widgets/chat/ai_model_dropdown.dart';
import '../../viewmodels/email_viewmodel.dart';
import '../../widgets/segment_toggle_button.dart';

class WritingScreen extends ConsumerStatefulWidget {
  const WritingScreen({super.key});

  @override
  ConsumerState<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends ConsumerState<WritingScreen> {
  final TextEditingController _originalTextController = TextEditingController();
  final TextEditingController _replyContentController = TextEditingController();

  final List<String> lengths = ['Auto', 'Short', 'Medium', 'Long'];
  final List<String> formalities = [
    'Auto',
    'Casual',
    'Neutral',
    'Formal',
    'Very Formal'
  ];
  final List<String> tones = [
    'Auto',
    'Amicable',
    'Casual',
    'Friendly',
    'Professional',
    'Witty',
    'Funny',
    'Formal'
  ];

  final List<String> supportedLanguages = [
    'Auto',
    'Arabic',
    'Bengali',
    'Chinese (Simplified)',
    'Chinese (Traditional)',
    'Czech',
    'Danish',
    'Dutch',
    'English',
    'Finnish',
    'French',
    'German',
    'Greek',
    'Hebrew',
    'Hindi',
    'Hungarian',
    'Indonesian',
    'Italian',
    'Japanese',
    'Korean',
    'Norwegian',
    'Polish',
    'Portuguese',
    'Romanian',
    'Russian',
    'Spanish',
    'Swedish',
    'Thai',
    'Turkish',
    'Ukrainian',
    'Vietnamese'
  ];
  final List<String> assistantNames = [
    'Auto',
    ...Assistant.assistants.map((assistant) => assistant.dto.name),
  ];

  @override
  Widget build(BuildContext context) {
    final emailState = ref.watch(emailStateProvider);
    final requestType = ref.watch(requestTypeProvider);
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              child: const Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'Reply Email',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.edit_outlined),
                    ],
                  ),
                ],
              ),
            ),
          ),
          drawer: const AppDrawer(),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection('Original Text'),
                        const SizedBox(height: 8),
                        _buildTextArea(
                          'The original text to which you want to reply...',
                          _originalTextController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        _buildSection('What To Reply'),
                        const SizedBox(height: 8),
                        _buildTextArea(
                          'The general content of your reply...',
                          _replyContentController,
                          maxLines: 3,
                        ),
                        if (requestType == RequestType.response) ...[
                          const SizedBox(height: 24),
                          _buildSection('Length'),
                          const SizedBox(height: 8),
                          _buildChipsSection(
                            lengths,
                            emailState.metadata.style.length,
                            (value) => ref
                                .read(emailStateProvider.notifier)
                                .updateStyle(length: value),
                          ),
                          const SizedBox(height: 16),
                          _buildSection('Formality'),
                          const SizedBox(height: 8),
                          _buildChipsSection(
                            formalities,
                            emailState.metadata.style.formality,
                            (value) => ref
                                .read(emailStateProvider.notifier)
                                .updateStyle(formality: value),
                          ),
                          const SizedBox(height: 16),
                          _buildSection('Tone'),
                          const SizedBox(height: 8),
                          _buildChipsSection(
                            tones,
                            emailState.metadata.style.tone,
                            (value) => ref
                                .read(emailStateProvider.notifier)
                                .updateStyle(tone: value),
                          ),
                        ],
                        const SizedBox(height: 16),
                        _buildSection('Output Language'),
                        const SizedBox(height: 8),
                        _buildLanguageDropdown(ref),
                        const SizedBox(height: 16),
                        _buildSection('Assistant'),
                        const SizedBox(height: 8),
                        _buildAssistantDropdown(ref),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextArea(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildChipsSection(
      List<String> options, String? selected, Function(String) onSelected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map((option) => _buildChip(
                option,
                selected == option || (selected == '' && option == 'Auto'),
                () => onSelected(option),
              ))
          .toList(),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade600,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF6366F1),
      backgroundColor: const Color(0xFFEEF2FF),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      pressElevation: 0,
      shadowColor: Colors.transparent,
      showCheckmark: false,
    );
  }

  Widget _buildLanguageDropdown(WidgetRef ref) {
    final currentLanguage = ref.watch(emailStateProvider).metadata.language;

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
          onSelected: (String language) => ref
              .read(emailStateProvider.notifier)
              .updateLanguage(language != 'Auto' ? language : ''),
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

  Widget _buildAssistantDropdown(WidgetRef ref) {
    final currentAssistantDto = ref.watch(emailStateProvider).assistant;

    final currentAssistant = currentAssistantDto != null
        ? Assistant.assistants.firstWhere(
            (assistant) => assistant.id == currentAssistantDto.id,
            orElse: () => Assistant.assistants.first)
        : null;

    return AIModelDropdown(
      assistants: Assistant.assistants,
      selectedAssistant: currentAssistant,
      onAssistantSelected: (Assistant? assistant) {
        ref.read(emailStateProvider.notifier).updateAssistant(
              assistant?.id,
            );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildToggleRequestTypeButtons(),
          const Spacer(),
          _buildRegenerateButton(),
        ],
      ),
    );
  }

  Widget _buildToggleRequestTypeButtons() {
    return Consumer(
      builder: (context, ref, child) {
        // Watch the current RequestType value
        final selectedRequestType = ref.watch(requestTypeProvider);

        return SegmentToggleButton(
          initialSegment: selectedRequestType.name,
          segments: {
            RequestType.response.name: 'Response',
            RequestType.replyIdeas.name: 'Reply Ideas',
          },
          onSegmentChanged: (selectedSegment) {
            // Update the RequestType state
            ref.read(requestTypeProvider.notifier).state =
                RequestType.values.firstWhere((e) => e.name == selectedSegment);
          },
        );
      },
    );
  }

  Widget _buildRegenerateButton() {
    return Consumer(
      builder: (context, ref, child) {
        final requestType = ref.watch(requestTypeProvider);
        final isFirstGeneration = ref.watch(isFirstGenerationProvider);

        return SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              final originalText = _originalTextController.text.trim();
              final replyContent = _replyContentController.text.trim();

              if (originalText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter the original email text'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              try {
                final emailNotifier = ref.read(emailStateProvider.notifier);
                emailNotifier.updateEmailContent(
                  email: originalText,
                  action: replyContent,
                );

                final response = await emailNotifier.generateEmail(requestType);

                if (isFirstGeneration) {
                  ref.read(isFirstGenerationProvider.notifier).state = false;
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email generated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error generating email: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isFirstGeneration ? Icons.create_outlined : Icons.refresh,
                    size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  isFirstGeneration ? 'Generate' : 'Regenerate',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
