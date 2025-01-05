import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/viewmodels/knowledge_base_viewmodel.dart';

class SlackScreen extends ConsumerStatefulWidget {
  final String knowledgeBaseId;

  const SlackScreen({super.key, required this.knowledgeBaseId});

  @override
  _SlackScreenState createState() => _SlackScreenState();
}

class _SlackScreenState extends ConsumerState<SlackScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _workspaceController = TextEditingController();
  final TextEditingController _botTokenController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _addSlackUnit() async {
    final name = _nameController.text;
    final workspace = _workspaceController.text;
    final botToken = _botTokenController.text;

    if (name.isEmpty || workspace.isEmpty || botToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name, Workspace, and Bot Token cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(kbViewModelProvider.notifier).addSlackUnit(
            widget.knowledgeBaseId,
            workspace,
            botToken,
            name,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slack unit added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding Slack unit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Unit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/slack.png',
                  width: 50.0,
                  height: 50.0,
                ),
                const SizedBox(width: 16.0),
                const Text(
                  'Slack',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 32.0),
            const Text(
              'Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Slack Workspace:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _workspaceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Slack Workspace',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Slack Bot Token:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _botTokenController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Slack Bot Token',
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _addSlackUnit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Connect'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
