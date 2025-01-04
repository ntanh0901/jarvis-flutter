import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_application/data/models/prompt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/prompt_library_viewmodel.dart';

Future<void> showPromptInfoDialog({
  required BuildContext context,
  required Prompt prompt,
  required WidgetRef ref,
  void Function(String)? onUsePrompt,
}) async {
  final ScrollController scrollController = ScrollController();
  double verticalPadding = 16.0;

  // Parse the prompt content to detect placeholders
  final RegExp placeholderRegExp = RegExp(r'\[(.*?)\]');
  final matches = placeholderRegExp.allMatches(prompt.content);
  final placeholders = matches.map((match) => match.group(0)!).toList();
  final Map<String, TextEditingController> controllers = {
    for (var placeholder in placeholders) placeholder: TextEditingController()
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final maxDialogHeight = MediaQuery.of(context).size.height * 0.7;
      final minDialogWidth = MediaQuery.of(context).size.width * 0.7;

      return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxDialogHeight,
            minWidth: minDialogWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      prompt.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
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
                      const SizedBox(width: 15.0),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        icon: const Icon(Icons.close,
                            color: Colors.grey, size: 20),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ListBody(
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Description: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: prompt.description ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Category: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: prompt.category ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Language: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: prompt.language ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Content:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.content_copy,
                      size: 15,
                      color: Color(0xff697079),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: prompt.content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Content copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: const Color(0xffF1F2F3),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding,
                      horizontal: 16.0,
                    ),
                    child: Text(
                      prompt.content,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
              if (placeholders.isNotEmpty) ...[
                const SizedBox(height: 16.0),
                const Text(
                  'Fill in the placeholders:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: placeholders.map((placeholder) {
                        final placeholderLabel =
                            placeholder.replaceAll('[', '').replaceAll(']', '');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: controllers[placeholder],
                            decoration: InputDecoration(
                              labelText: placeholderLabel,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF6841EA),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            icon: const Icon(
              CupertinoIcons.conversation_bubble,
              color: Colors.white,
              size: 20.0,
            ),
            label: const Text(
              'Use Prompt',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // Replace placeholders with user input
              String modifiedContent = prompt.content;
              controllers.forEach((placeholder, controller) {
                modifiedContent = modifiedContent.replaceAll(placeholder,
                    controller.text.isEmpty ? placeholder : controller.text);
              });

              // close dialog if needed
              Navigator.of(context).pop();

              if (onUsePrompt != null) {
                onUsePrompt(modifiedContent);
              } else {
                // use context.goNamed to replace the current route
                context.goNamed(
                  'Chat',
                  extra: prompt.copyWith(
                      content:
                          modifiedContent), // pass the modified Prompt through extra
                );
              }
            },
          )
        ],
      );
    },
  );

  scrollController.addListener(() {
    verticalPadding = scrollController.offset > 0 ? 0.0 : 16.0;
  });
}

Future<void> showModalBottomSheetPrompts({
  required BuildContext context,
  required WidgetRef ref,
  required void Function(Prompt prompt) onPromptSelected,
}) async {
  final promptNotifier = ref.read(promptViewModelProvider.notifier);
  await promptNotifier.fetchPublicPrompts();

  if (!context.mounted) return;

  final prompts = ref.read(promptViewModelProvider).publicPrompts;

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: prompts.map((prompt) {
            return ListTile(
              title: Text(prompt.title),
              onTap: () {
                Navigator.pop(context);
                onPromptSelected(prompt);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}
