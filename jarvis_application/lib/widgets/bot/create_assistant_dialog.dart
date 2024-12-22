import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ai_bot_provider.dart';

class CreateAssistantDialog extends ConsumerStatefulWidget {
  final String title;
  final String? initialName;
  final String? initialInstructions;
  final String? initialDescription;
  final Function(String name, String instructions, String description)? onUpdate;

  const CreateAssistantDialog({
    Key? key,
    required this.title,
    this.initialName,
    this.initialInstructions,
    this.initialDescription,
    this.onUpdate,
  }) : super(key: key);

  @override
  ConsumerState<CreateAssistantDialog> createState() => _CreateAssistantDialogState();
}

class _CreateAssistantDialogState extends ConsumerState<CreateAssistantDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    // Khởi tạo giá trị ban đầu từ các tham số
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _instructionsController = TextEditingController(text: widget.initialInstructions ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

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

  Future<void> _updateAssistant() async {
    if (widget.onUpdate != null) {
      try {
        // Gọi hàm cập nhật được truyền vào
        widget.onUpdate!(
          _nameController.text,
          _instructionsController.text,
          _descriptionController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assistant updated successfully!')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Assistant Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
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
          onPressed: widget.onUpdate != null ? _updateAssistant : _createAssistant,
          child: Text(widget.onUpdate != null ? 'Update' : 'Create'),
        ),
      ],
    );
  }

}
