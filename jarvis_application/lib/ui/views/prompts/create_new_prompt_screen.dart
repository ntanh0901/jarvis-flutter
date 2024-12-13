import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/views/prompts/api_prompts.dart';

class CreateNewPrompt extends StatefulWidget {
  const CreateNewPrompt({super.key});

  @override
  _CreateNewPromptState createState() => _CreateNewPromptState();
}

class _CreateNewPromptState extends State<CreateNewPrompt> {
  bool isPrivatePrompt = true;
  String selectedLanguage = 'English';
  String selectedCategory = 'other';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  final List<String> categories = [
    'other',
    'carrer',
    'bussiness',
    'writing',
    'productivity',
    'coding',
    'marketing',
    'seo',
    'education',
    'chatbot',
    'fun'
  ];

  Future<void> createPrompt() async {
    try {
      await ApiService.createPrompt(
        category: isPrivatePrompt ? 'other' : selectedCategory,
        content: contentController.text,
        description: isPrivatePrompt ? 'nothing' : descriptionController.text,
        isPublic: !isPrivatePrompt,
        language: isPrivatePrompt ? 'English' : selectedLanguage,
        title: titleController.text,
      );
      // Prompt created successfully
      Navigator.pop(context, true);
    } catch (e) {
      // Handle error
      print('Failed to create prompt: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Prompt'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Private Prompt'),
                    value: true,
                    groupValue: isPrivatePrompt,
                    onChanged: (bool? value) {
                      setState(() {
                        isPrivatePrompt = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Public Prompt'),
                    value: false,
                    groupValue: isPrivatePrompt,
                    onChanged: (bool? value) {
                      setState(() {
                        isPrivatePrompt = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (isPrivatePrompt) ...[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prompt',
                ),
              ),
            ] else ...[
              DropdownButtonFormField<String>(
                value: selectedLanguage,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prompt Language',
                ),
                items: languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prompt',
                ),
              ),
            ],
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: createPrompt,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
