import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jarvis_application/data/models/prompt.dart';

import '../../viewmodels/prompt_library_viewmodel.dart';

Future<void> showPromptInfoDialog({
  required BuildContext context,
  required Prompt prompt,
  required WidgetRef ref,
  void Function(String)? onUsePrompt,
}) async {
  final ScrollController scrollController = ScrollController();
  double verticalPadding = 16.0;

  final RegExp placeholderRegExp = RegExp(r'\[(.*?)\]');
  final matches = placeholderRegExp.allMatches(prompt.content);
  final placeholders = matches.map((match) => match.group(0)!).toList();
  final Map<String, TextEditingController> controllers = {
    for (var placeholder in placeholders) placeholder: TextEditingController()
  };

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  16.0, // Add padding for keyboard
            ),
            child: SingleChildScrollView(
              // Wrap entire content in SingleChildScrollView
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          prompt.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    // Use theme text styles
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (prompt.isPublic ?? false) ...[
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                (prompt.isFavorite ?? false)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: (prompt.isFavorite ?? false)
                                    ? Colors.red
                                    : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () async {
                                await ref
                                    .read(promptViewModelProvider.notifier)
                                    .toggleFavorite(prompt);
                                (context as Element).markNeedsBuild();
                              },
                            ),
                          ],
                          const SizedBox(width: 15.0),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.close,
                                color: Colors.grey, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  _buildInfoSection(
                      'Description', prompt.description ?? 'N/A', context),
                  const SizedBox(height: 8.0),
                  _buildInfoSection(
                      'Category', prompt.category ?? 'N/A', context),
                  const SizedBox(height: 8.0),
                  _buildInfoSection(
                      'Language', prompt.language ?? 'N/A', context),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Content:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.content_copy,
                          size: 15,
                          color: Color(0xff697079),
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: prompt.content));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Content copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: const Color(0xffF1F2F3),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        prompt.content,
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                  ),
                  if (placeholders.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Fill in the placeholders:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ...placeholders.map((placeholder) {
                      final placeholderLabel =
                          placeholder.replaceAll('[', '').replaceAll(']', '');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: const Color(0xffF1F2F3),
                          ),
                          child: TextField(
                            controller: controllers[placeholder],
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: placeholderLabel,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 16.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF6841EA),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        icon: const Icon(
                          CupertinoIcons.conversation_bubble,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        label: Text(
                          'Use Prompt',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        onPressed: () {
                          String modifiedContent = prompt.content;
                          controllers.forEach((placeholder, controller) {
                            modifiedContent = modifiedContent.replaceAll(
                              placeholder,
                              controller.text.isEmpty
                                  ? placeholder
                                  : controller.text,
                            );
                          });

                          Navigator.of(context).pop();

                          if (onUsePrompt != null) {
                            onUsePrompt(modifiedContent);
                          } else {
                            context.goNamed(
                              'Chat',
                              extra: prompt.copyWith(content: modifiedContent),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildInfoSection(String label, String content, BuildContext context) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        TextSpan(
          text: content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}

// Future<void> showPromptMenu({
//   required BuildContext context,
//   required WidgetRef ref,
//   required void Function(Prompt prompt) onPromptSelected,
//   required Offset position,
// }) async {
//   final promptNotifier = ref.read(promptViewModelProvider.notifier);
//   await promptNotifier.fetchPublicPrompts();
//
//   if (!context.mounted) return;
//
//   final prompts = ref.read(promptViewModelProvider).publicPrompts;
//
//   final selectedPrompt = await showMenu<Prompt>(
//     context: context,
//     position: RelativeRect.fromLTRB(
//         position.dx, position.dy, position.dx, position.dy),
//     items: [
//       PopupMenuItem<Prompt>(
//         enabled: false,
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxHeight: 200), // Limit the height
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: prompts.map((prompt) {
//                 return ListTile(
//                   title: Text(prompt.title),
//                   onTap: () {
//                     Navigator.pop(context, prompt);
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
//
//   if (selectedPrompt != null) {
//     onPromptSelected(selectedPrompt);
//   }
// }

Future<void> showPromptMenu({
  required BuildContext context,
  required WidgetRef ref,
  required void Function(Prompt prompt) onPromptSelected,
  required Offset position,
}) async {
  final promptNotifier = ref.read(promptViewModelProvider.notifier);
  await promptNotifier.fetchPublicPrompts();

  if (!context.mounted) return;

  final prompts = ref.read(promptViewModelProvider).publicPrompts;

  await showDialog(
    context: context,
    useSafeArea: false,
    barrierColor: Colors.transparent,
    builder: (context) => _PromptMenuOverlay(
      position: position,
      prompts: prompts,
      onPromptSelected: (prompt) {
        Navigator.of(context).pop();
        onPromptSelected(prompt);
      },
    ),
  );
}

class _PromptMenuOverlay extends StatefulWidget {
  final Offset position;
  final List<Prompt> prompts;
  final Function(Prompt) onPromptSelected;

  const _PromptMenuOverlay({
    required this.position,
    required this.prompts,
    required this.onPromptSelected,
  });

  @override
  State<_PromptMenuOverlay> createState() => _PromptMenuOverlayState();
}

class _PromptMenuOverlayState extends State<_PromptMenuOverlay> {
  List<Prompt> filteredPrompts = [];
  final layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    filteredPrompts = widget.prompts;
  }

  void _filterPrompts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPrompts = widget.prompts;
        return;
      }

      query = query.toLowerCase().replaceFirst('/', '');
      filteredPrompts = widget.prompts.where((prompt) {
        return prompt.title.toLowerCase().contains(query) ||
                prompt.description!.toLowerCase().contains(query) ??
            false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent barrier for dismissing
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),

        // Prompt menu
        Positioned(
          left: widget.position.dx,
          top: widget.position.dy,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                maxWidth: MediaQuery.of(context).size.width -
                    32, // Padding on both sides
              ),
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: filteredPrompts.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) {
                        final prompt = filteredPrompts[index];
                        return InkWell(
                          onTap: () => widget.onPromptSelected(prompt),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/images/chat.png',
                                    width: 20,
                                    height: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        prompt.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      if (prompt.description != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          prompt.description!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (filteredPrompts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No prompts found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
