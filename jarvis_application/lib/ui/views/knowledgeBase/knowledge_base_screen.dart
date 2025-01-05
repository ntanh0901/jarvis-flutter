import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/widgets/app_drawer.dart';

import '../../viewmodels/knowledge_base_viewmodel.dart';
import '../../widgets/create_kb_button.dart';
import '../../widgets/knowledge_base_list_view.dart';
import '../../widgets/search_text_field.dart';

class KnowledgeBase extends ConsumerStatefulWidget {
  const KnowledgeBase({super.key});

  @override
  _KnowledgeBaseState createState() => _KnowledgeBaseState();
}

class _KnowledgeBaseState extends ConsumerState<KnowledgeBase> {
  @override
  void initState() {
    super.initState();
    // Fetch knowledge bases when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kbViewModelProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final kbState = ref.watch(kbViewModelProvider);

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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SearchTextField(
                        id: 'searchKb',
                        onChange: (query) {
                          ref
                              .read(kbViewModelProvider.notifier)
                              .changeSearchQuery(query);
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const CreateKBButton(),
                  ],
                ),
              ),
              kbState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : KnowledgeBaseListView(
                      knowledgeBases: kbState.filteredKnowledgeBases),
            ],
          ),
        ),
      ),
    );
  }
}
