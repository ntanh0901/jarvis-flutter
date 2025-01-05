import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/knowledge_base_viewmodel.dart';

class CreateNewKB extends ConsumerStatefulWidget {
  const CreateNewKB({super.key});

  @override
  _CreateNewKBState createState() => _CreateNewKBState();
}

class _CreateNewKBState extends ConsumerState<CreateNewKB> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Knowledge'),
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
                      await ref
                          .read(kbViewModelProvider.notifier)
                          .createKnowledgeBase(name, description);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Knowledge base created successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error creating knowledge base: $e'),
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
