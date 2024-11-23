import 'package:flutter/material.dart';
import 'package:jarvis_application/screens/prompts/create_new_prompt_screen.dart';
import 'package:jarvis_application/screens/prompts/prompt_library_screen.dart';

class CreatePromptButton extends StatelessWidget {
  const CreatePromptButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.lightBlue,
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
                  context
                      .findAncestorStateOfType<PromptLibraryState>()!
                      .refreshPrompts();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
