import 'package:flutter/material.dart';

import '../views/prompts/create_new_prompt_screen.dart';
import '../views/prompts/prompt_library_screen.dart';

class CreatePromptButton extends StatelessWidget {
  final VoidCallback onPromptCreated;
  const CreatePromptButton({super.key, required this.onPromptCreated});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          width: 40.0,
          height: 40.0,
          decoration: const ShapeDecoration(
            color: Color(0xff6841EA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: () async {
              // Add new prompt
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateNewPrompt()),
              );

              if (result == true) {
                // A new prompt was created, refresh the prompts
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Prompt created successfully')),
                );
                // Call a method to refresh the prompts
                if (context.findAncestorStateOfType<PromptLibraryState>() !=
                    null) {
                  onPromptCreated();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
