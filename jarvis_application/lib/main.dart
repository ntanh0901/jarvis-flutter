import 'package:flutter/material.dart';
import 'package:jarvis_application/screens/knowledgeBase/knowledge_base_screen.dart';
import 'package:jarvis_application/screens/prompts/prompt_library_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KnowledgeBase(),
      //home: const PromptLibrary(),
    );
  }
}

