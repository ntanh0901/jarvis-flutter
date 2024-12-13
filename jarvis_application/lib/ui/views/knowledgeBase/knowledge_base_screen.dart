import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/widgets/app_drawer.dart';

import '../../widgets/create_kb_button.dart';
import '../../widgets/knowledge_base_list_view.dart';
import '../../widgets/search_text_field.dart';

class KnowledgeBase extends StatelessWidget {
  const KnowledgeBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Base'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: const Row(
                children: <Widget>[
                  Expanded(child: SearchTextField()),
                  SizedBox(width: 16.0),
                  // Add margin between the search field and the button
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
