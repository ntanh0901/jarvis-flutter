import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/viewmodels/knowledge_base_viewmodel.dart';

class ConfluenceScreen extends ConsumerStatefulWidget {
  final String knowledgeBaseId;

  const ConfluenceScreen({super.key, required this.knowledgeBaseId});

  @override
  _ConfluenceScreenState createState() => _ConfluenceScreenState();
}

class _ConfluenceScreenState extends ConsumerState<ConfluenceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wikiPageUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _accessTokenController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _addConfluenceUnit() async {
    final name = _nameController.text;
    final wikiPageUrl = _wikiPageUrlController.text;
    final username = _usernameController.text;
    final accessToken = _accessTokenController.text;

    if (name.isEmpty ||
        wikiPageUrl.isEmpty ||
        username.isEmpty ||
        accessToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(kbViewModelProvider.notifier).addConfluenceUnit(
            widget.knowledgeBaseId,
            name,
            wikiPageUrl,
            username,
            accessToken,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confluence unit added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding Confluence unit: $e'),
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
                  'assets/confluence.png',
                  width: 50.0,
                  height: 50.0,
                ),
                const SizedBox(width: 16.0),
                const Text(
                  'Confluence',
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
              'Wiki Page URL:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _wikiPageUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Wiki Page URL',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Confluence Username:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confluence Username',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Confluence Access Token:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _accessTokenController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confluence Access Token',
              ),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _addConfluenceUnit,
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
