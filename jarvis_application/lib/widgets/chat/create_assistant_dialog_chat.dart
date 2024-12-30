import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/bot/ai_assistant.dart';
import '../../ui/views/aiBots/bot_chat_page.dart';

class CreateAssistantDialogChat extends ConsumerStatefulWidget {
  final String title;
  final String? initialName;
  final String? initialInstructions;
  final String? initialDescription;
  final Function(String name, String instructions, String description)?
      onUpdate;

  const CreateAssistantDialogChat({
    Key? key,
    required this.title,
    this.initialName,
    this.initialInstructions,
    this.initialDescription,
    this.onUpdate,
  }) : super(key: key);

  @override
  ConsumerState<CreateAssistantDialogChat> createState() =>
      _CreateAssistantDialogChatState();
}

class _CreateAssistantDialogChatState
    extends ConsumerState<CreateAssistantDialogChat> {
  late final TextEditingController _nameController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _descriptionController;
  final String baseUrl = 'https://knowledge-api.jarvis.cx';
  final String apiToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImY4YzA4ZDNmLTIyMzEtNDE5Ni04ZTVmLTEzZDgwNjRlOWNkMSIsImVtYWlsIjoicXVhbmd0aGllbjEyMzRAZ21haWwuY29tIiwiaWF0IjoxNzM1NTE2ODE4LCJleHAiOjE3MzU2MDMyMTh9.kjYVBDGL6rv6zzV5oUFQpQptSfpayKTmyUPo6X1Xsis';

  AIAssistant? currentAssistant;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _instructionsController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  Future<void> createAIAssistant(String name, String instructions, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kb-core/v1/ai-assistant'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
        body: jsonEncode({
          'assistantName': name,
          'instructions': instructions,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        // Parse response JSON và tạo instance của AIAssistant
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        currentAssistant = AIAssistant.fromJson(responseData);

        // Chuyển tới BotChatPage
        if (currentAssistant != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BotChatPage(
                currentAssistant: currentAssistant!,
                openAiThreadId: currentAssistant!.openAiThreadIdPlay,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create assistant: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating assistant: $e')),
      );
    }
  }

  Future<void> _createAssistant() async {
    final name = _nameController.text.trim();
    final instructions = _instructionsController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || instructions.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    await createAIAssistant(name, instructions, description);
  }

  Future<void> _updateAssistant() async {}

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
          onPressed:
              widget.onUpdate != null ? _updateAssistant : _createAssistant,
          child: Text(widget.onUpdate != null ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
