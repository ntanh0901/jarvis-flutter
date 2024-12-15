import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/views/knowledgeBase/create_new_kb_screen.dart';

class CreateKBButton extends StatelessWidget {
  const CreateKBButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
          child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.add),
          color: Colors.white,
          onPressed: () {
            // Add new knowledge base
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateNewKB()),
            );
          },
        ),
      )),
    );
  }
}
