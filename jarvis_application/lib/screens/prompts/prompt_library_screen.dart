import 'package:flutter/material.dart';

import '../../ui/widgets/create_prompt_button.dart';
import '../../ui/widgets/prompts_switch_button.dart';
import '../../ui/widgets/search_text_field.dart';

class PromptLibrary extends StatefulWidget {
  const PromptLibrary({super.key});

  @override
  _PromptLibraryState createState() => _PromptLibraryState();
}

class _PromptLibraryState extends State<PromptLibrary> {
  bool isMyPromptSelected = true;
  String selectedCategory = 'All';

  final List<Map<String, String>> myPrompts = [
    {'name': 'Brainstorm'},
    {'name': 'Translate to Japanese'},
    {'name': 'Grammar Check'},
    // Add more prompts here
  ];

  final List<Map<String, String>> publicPrompts = [
    {
      'name': 'Learn code FAST!',
      'description':
          'Teach you the code with the most understandable knowledge.'
    },
    {
      'name': 'Story generator',
      'description': 'Write your own beautiful story.'
    },
    {
      'name': 'Essay improver',
      'description': 'Improve your content\'s effectiveness with ease.'
    },
    // Add more public prompts here
  ];

  final List<String> categories = [
    'All',
    'Marketing',
    'AI Painting',
    'Chatbot',
    'SEO',
    'Writing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Library'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CreatePromptButton(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: PromptsSwitchButton(
                isMyPromptSelected: isMyPromptSelected,
                onMyPromptSelected: () {
                  setState(() {
                    isMyPromptSelected = true;
                  });
                },
                onPublicPromptSelected: () {
                  setState(() {
                    isMyPromptSelected = false;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          if (!isMyPromptSelected) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SearchTextField(),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonFormField<String>(
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
            ),
            const SizedBox(height: 16.0),
          ],
          Expanded(
            child: ListView.separated(
              itemCount:
                  isMyPromptSelected ? myPrompts.length : publicPrompts.length,
              itemBuilder: (context, index) {
                final prompt = isMyPromptSelected
                    ? myPrompts[index]
                    : publicPrompts[index];
                return ListTile(
                  title: Text(prompt['name']!),
                  subtitle:
                      isMyPromptSelected ? null : Text(prompt['description']!),
                  trailing: isMyPromptSelected
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Handle edit prompt action
                          },
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {
                                // Handle favorite action
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                // Handle information action
                              },
                            ),
                          ],
                        ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
