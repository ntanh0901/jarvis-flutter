import 'package:flutter/material.dart';

class EditKB extends StatefulWidget {
  final String name;
  final String description;

  const EditKB({super.key, required this.name, required this.description});

  @override
  _EditKBState createState() => _EditKBState();
}

class _EditKBState extends State<EditKB> {
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
                  onPressed: () {
                    // Handle confirm action
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