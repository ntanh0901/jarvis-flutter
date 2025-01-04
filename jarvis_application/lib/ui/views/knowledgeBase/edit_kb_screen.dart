import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/knowledge_base_viewmodel.dart';

class EditKB extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String description;

  const EditKB({
    super.key,
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  _EditKBState createState() => _EditKBState();
}

class _EditKBState extends ConsumerState<EditKB> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Knowledge Base'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Icon(
                Icons.storage_rounded,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              maxLength: 50,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Knowledge Name',
                counterText: '${_nameController.text.length} / 50',
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              maxLength: 5000,
              maxLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Knowledge Description',
                counterText: '${_descriptionController.text.length} / 5000',
                floatingLabelAlignment: FloatingLabelAlignment.start,
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text;
                    final description = _descriptionController.text;

                    if (name.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Name and description cannot be empty'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      print(widget.id);
                      await ref
                          .read(kbViewModelProvider.notifier)
                          .updateKnowledgeBase(
                            widget.id,
                            name,
                            description,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Knowledge base updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error updating knowledge base: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
