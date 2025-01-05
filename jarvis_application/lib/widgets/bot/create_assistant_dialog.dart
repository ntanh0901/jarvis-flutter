import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/ai_bot_provider.dart';

class CreateAssistantDialog extends ConsumerStatefulWidget {
  final String title;
  final String? initialName;
  final String? initialInstructions;
  final String? initialDescription;
  final Function(String name, String instructions, String description)?
      onUpdate;

  const CreateAssistantDialog({
    Key? key,
    required this.title,
    this.initialName,
    this.initialInstructions,
    this.initialDescription,
    this.onUpdate,
  }) : super(key: key);

  @override
  ConsumerState<CreateAssistantDialog> createState() =>
      _CreateAssistantDialogState();
}

class _CreateAssistantDialogState extends ConsumerState<CreateAssistantDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _instructionsController =
        TextEditingController(text: widget.initialInstructions ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createAssistant() async {
    if (_nameController.text.isEmpty ||
        _instructionsController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = ref.read(aiAssistantProvider.notifier);

    try {
      await provider.createAIAssistant(
        _nameController.text,
        _instructionsController.text,
        _descriptionController.text,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Created assistant "${_nameController.text}" successfully'),
            backgroundColor: Colors.green[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create assistant: $e'),
            backgroundColor: Colors.red[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  Future<void> _updateAssistant() async {
    if (_nameController.text.isEmpty ||
        _instructionsController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if any changes were made
    if (widget.initialName == _nameController.text &&
        widget.initialInstructions == _instructionsController.text &&
        widget.initialDescription == _descriptionController.text) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes made'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    if (widget.onUpdate != null) {
      try {
        widget.onUpdate!(
          _nameController.text,
          _instructionsController.text,
          _descriptionController.text,
        );
        Navigator.of(context).pop();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating assistant: $e'),
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double minDialogWidth = MediaQuery.of(context).size.width * 0.8;

    return AlertDialog(
      iconPadding: const EdgeInsets.only(top: 10, right: 10),
      icon: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.grey, size: 20),
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minDialogWidth,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter assistant name',
                hintStyle: const TextStyle(color: Color(0xFF89929D)),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Instructions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color(0xffF1F2F3),
                ),
                child: TextField(
                  controller: _instructionsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF1F5F9),
                    contentPadding: EdgeInsets.all(16.0),
                    border: InputBorder.none,
                    hintText: 'Enter instructions',
                    hintStyle: TextStyle(color: Color(0xFF89929D)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color(0xffF1F2F3),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF1F5F9),
                    contentPadding: EdgeInsets.all(16.0),
                    border: InputBorder.none,
                    hintText: 'Enter description',
                    hintStyle: TextStyle(color: Color(0xFF89929D)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF6841EA),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed:
              widget.onUpdate != null ? _updateAssistant : _createAssistant,
          child: Text(
            widget.onUpdate != null ? 'Save' : 'Create',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
