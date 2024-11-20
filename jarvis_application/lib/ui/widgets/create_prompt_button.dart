import 'package:flutter/material.dart';
import 'package:jarvis_application/screens/prompts/create_new_prompt_screen.dart';

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
          onPressed: () {
            // Add new prompt
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateNewPrompt()),
            );
          },
        ),
      )),
    );
  }
}