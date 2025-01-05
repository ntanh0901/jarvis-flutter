import 'package:flutter/material.dart';

import '../views/prompts/create_prompt_sheet.dart';
import '../views/prompts/prompt_library_screen.dart';

class CreatePromptButton extends StatelessWidget {
  final VoidCallback onPromptCreated;
  const CreatePromptButton({super.key, required this.onPromptCreated});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        width: 36.0,
        height: 36.0,
        decoration: const ShapeDecoration(
          color: Color(0xff6841EA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.add,
            size: 24,
          ),
          color: Colors.white,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () async {
            final result = await showModalBottomSheet<bool>(
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              builder: (context) => const CreatePromptSheet(),
            );
            // if result empty
            if (result == null) return;
            if (result == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prompt created successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              if (context.findAncestorStateOfType<PromptLibraryState>() !=
                  null) {
                onPromptCreated();
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prompt creation failed')),
              );
            }
          },
        ),
      ),
    );
  }
}
