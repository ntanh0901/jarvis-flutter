import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ai_bot_provider.dart';

class CreateAssistantDialog extends ConsumerStatefulWidget {
  const CreateAssistantDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateAssistantDialog> createState() => _CreateAssistantDialogState();
}

class _CreateAssistantDialogState extends ConsumerState<CreateAssistantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _createAssistant() async {
    final provider = ref.read(aiAssistantProvider.notifier);

    try {
      await provider.createAIAssistant(
        _nameController.text,
        _instructionsController.text,
        _descriptionController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assistant created successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Assistant'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Assistant Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(labelText: 'Instructions'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createAssistant,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
