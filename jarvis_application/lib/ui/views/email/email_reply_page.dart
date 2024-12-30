// lib/views/writing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  final ScrollController _scrollController = ScrollController();

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

    ref.listen<bool>(isLoadingProvider, (previous, current) {
      if (previous == true && current == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            if (_originalTextController.text.isEmpty) {
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            } else {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        });
      }
    });

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
              padding: const EdgeInsets.symmetric(vertical: 12),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
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
                          const SizedBox(height: 16),
                          _buildPreviewWidget(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
        final selectedRequestType = ref.watch(requestTypeProvider);

        return SegmentToggleButton(
          initialSegment: selectedRequestType.name,
          segments: {
            RequestType.response.name: 'Response',
            RequestType.replyIdeas.name: 'Reply Ideas',
          },
          onSegmentChanged: (selectedSegment) {
            final newState =
                RequestType.values.firstWhere((e) => e.name == selectedSegment);
            ref.read(requestTypeProvider.notifier).state = newState;
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
        final isLoading = ref.watch(isLoadingProvider);

        return SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              if (isLoading) {
                // Stop the ongoing request
                ref.read(isLoadingProvider.notifier).state = false;
              } else {
                _handleGenerateEmail(ref, requestType, isFirstGeneration);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isLoading ? Colors.red.shade100 : Colors.blue.shade50,
              foregroundColor: isLoading ? Colors.red.shade600 : Colors.blue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLoading
                      ? Icons.stop_circle_outlined
                      : (isFirstGeneration
                          ? Icons.create_outlined
                          : Icons.refresh),
                  size: 18,
                  color: isLoading ? Colors.red.shade600 : Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  isLoading
                      ? 'Stop'
                      : (isFirstGeneration ? 'Generate' : 'Regenerate'),
                  style: TextStyle(
                    fontWeight: isLoading ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleGenerateEmail(
      WidgetRef ref, RequestType requestType, bool isFirstGeneration) async {
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final originalText = _originalTextController.text.trim();
      final replyContent = _replyContentController.text.trim();

      if (originalText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter the original email text'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }

      final emailNotifier = ref.read(emailStateProvider.notifier);
      emailNotifier.updateEmailContent(
        email: originalText,
        action: replyContent,
      );
      await emailNotifier.generateEmail(requestType, ref);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Widget _buildPreviewWidget() {
    return Consumer(
      builder: (context, ref, child) {
        final requestType = ref.watch(requestTypeProvider);
        final currentIndex = ref.watch(currentIndexProvider);
        final contents = ref.watch(generatedContentProvider);
        final isLoading = ref.watch(isLoadingProvider);

        if (contents.isEmpty) {
          return const SizedBox.shrink();
        }

        // For response type, only show if the last generated content was a response
        if (requestType == RequestType.response && contents.length > 1) {
          return const SizedBox.shrink();
        }

        // For reply ideas, only show if the last generated content was reply ideas
        if (requestType == RequestType.replyIdeas && contents.length == 1) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Type text
                  _buildSection(requestType == RequestType.replyIdeas
                      ? 'Reply Ieas'
                      : 'Response'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy_outlined, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: contents[currentIndex],
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    color: Colors.grey.shade700,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Copy to clipboard',
                  ),
                  if (requestType == RequestType.replyIdeas) ...[
                    // Navigation icons for reply ideas
                    GestureDetector(
                      onTap: currentIndex > 0
                          ? () =>
                              ref.read(currentIndexProvider.notifier).state--
                          : null,
                      child: Icon(
                        Icons.chevron_left,
                        size: 16,
                        color: currentIndex > 0
                            ? Colors.grey.shade700
                            : Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      ' ${currentIndex + 1}/${contents.length}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: currentIndex < contents.length - 1
                          ? () =>
                              ref.read(currentIndexProvider.notifier).state++
                          : null,
                      child: Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: currentIndex < contents.length - 1
                            ? Colors.grey.shade700
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ],
              ),
              // Content display
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    isLoading
                        ? const Center(
                            child: SpinKitThreeBounce(
                              color: Colors.blue,
                              size: 24.0,
                            ),
                          )
                        : Text(
                            contents[currentIndex],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
