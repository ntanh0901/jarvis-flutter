import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/ai_bot_provider.dart';
import '../../../widgets/bot/assistant_item.dart';
import '../../../widgets/bot/create_assistant_dialog.dart';
import '../../widgets/app_drawer.dart';
import 'bot_chat_page.dart';

class BotListPage extends ConsumerStatefulWidget {
  static const String routeName = '/bot-list';

  const BotListPage({super.key});

  @override
  ConsumerState<BotListPage> createState() => _BotListPageState();
}

class _BotListPageState extends ConsumerState<BotListPage> {
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAssistants(true);
  }

  Future<void> _loadAssistants(bool isAppeared) async {
    setState(() {
      _isLoading = isAppeared; // Hiển thị trạng thái loading
    });

    try {
      await ref.read(aiAssistantProvider.notifier).fetchAIAssistants();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load assistants. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false; // Tắt trạng thái loading sau khi hoàn tất
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assistants = ref.watch(aiAssistantProvider);

    final filteredAssistants = assistants
        .where((assistant) => assistant.assistantName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AI Assistants',
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _loadAssistants(true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search AI Assistants',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredAssistants.length,
                          itemBuilder: (context, index) {
                            final assistant = filteredAssistants[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BotChatPage(
                                      currentAssistant: assistant,
                                      openAiThreadId:
                                          assistant.openAiThreadIdPlay,
                                    ),
                                  ),
                                );
                              },
                              child: AssistantItem(
                                id: assistant.id,
                                name: assistant.assistantName,
                                description: assistant.description,
                                instructions: assistant.instructions,
                                createdAt: assistant.createdAt,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) =>
                  const CreateAssistantDialog(title: 'Create New Assistant'),
            );
            _loadAssistants(false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
