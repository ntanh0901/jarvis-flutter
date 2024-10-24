import 'package:flutter/material.dart';
import 'package:jarvis_application/widgets/create_kb_button.dart';
import 'package:jarvis_application/widgets/knowledge_base_list_view.dart';
import 'package:jarvis_application/widgets/search_text_field.dart';

class KnowledgeBase extends StatelessWidget {
  const KnowledgeBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Base'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: const Row(
                children: <Widget>[
                  Expanded(child: SearchTextField()),
                  SizedBox(
                      width:
                          16.0), // Add margin between the search field and the button
                  CreateKBButton(),
                ],
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            const KnowledgeBaseListView(),
          ],
        ),
      ),
    );
  }
}