import 'package:flutter/material.dart';
import 'package:jarvis_application/ui/widgets/app_drawer.dart';

import '../../widgets/create_kb_button.dart';
import '../../widgets/knowledge_base_list_view.dart';
import '../../widgets/search_text_field.dart';

class KnowledgeBase extends StatelessWidget {
  const KnowledgeBase({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Knowledge Base',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              color: Colors.grey[200],
              height: 1,
            ),
          ),
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Row(
                  children: <Widget>[
                    Expanded(
                        child: SearchTextField(
                      id: 'searchKb',
                    )),
                    SizedBox(width: 16.0),
                    CreateKBButton(),
                  ],
                ),
              ),
              const KnowledgeBaseListView(),
            ],
          ),
        ),
      ),
    );
  }
}
