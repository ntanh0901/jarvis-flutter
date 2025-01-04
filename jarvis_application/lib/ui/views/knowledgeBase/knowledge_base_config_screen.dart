import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jarvis_application/ui/views/knowledgeBase/add_new_unit_screen.dart';
import 'package:jarvis_application/ui/views/knowledgeBase/edit_kb_screen.dart';

import '../../viewmodels/knowledge_base_viewmodel.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/create_unit_button.dart';
import '../../widgets/units_list_view.dart';

class KnowledgeBaseConfiguration extends ConsumerStatefulWidget {
  final Map<String, dynamic> knowledgeBase;

  const KnowledgeBaseConfiguration({super.key, required this.knowledgeBase});

  @override
  _KnowledgeBaseConfigurationState createState() =>
      _KnowledgeBaseConfigurationState();
}

class _KnowledgeBaseConfigurationState
    extends ConsumerState<KnowledgeBaseConfiguration> {
  late Map<String, dynamic> _knowledgeBase;

  @override
  void initState() {
    super.initState();
    _knowledgeBase = widget.knowledgeBase;
    // Fetch units when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(kbViewModelProvider.notifier)
          .fetchKnowledgeBaseUnits(_knowledgeBase['id']);
    });
  }

  Future<void> _refreshKnowledgeBase() async {
    await ref
        .read(kbViewModelProvider.notifier)
        .fetchKnowledgeBaseDetails(_knowledgeBase['id']);
    final updatedKnowledgeBase = ref
        .read(kbViewModelProvider)
        .knowledgeBases
        .firstWhere((kb) => kb.id == _knowledgeBase['id']);
    setState(() {
      _knowledgeBase = {
        'id': updatedKnowledgeBase.id,
        'name': updatedKnowledgeBase.knowledgeName,
        'description': updatedKnowledgeBase.description,
        'icon': _knowledgeBase['icon'],
        'units': updatedKnowledgeBase.numUnits,
        'size': updatedKnowledgeBase.totalSize,
      };
    });
  }

  String _formatSize(int sizeInBytes) {
    final sizeInMB = sizeInBytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(1)}MB';
  }

  @override
  Widget build(BuildContext context) {
    final kbState = ref.watch(kbViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Knowledge Base / ${_knowledgeBase['name']}'),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    _knowledgeBase['icon'] ?? Icons.storage_rounded,
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            _knowledgeBase['name'] ?? 'Unknown',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditKB(
                                    id: _knowledgeBase['id'] ?? '',
                                    name: _knowledgeBase['name'] ?? '',
                                    description:
                                        _knowledgeBase['description'] ?? '',
                                  ),
                                ),
                              );
                              // Refresh the knowledge base data after returning from the edit screen
                              await _refreshKnowledgeBase();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Text('Units: ${_knowledgeBase['units'] ?? 0}'),
                          const SizedBox(width: 16.0),
                          Text(
                              'Size: ${_formatSize(_knowledgeBase['size'] ?? 0)}'),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  CreateUnitButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewUnit(
                            knowledgeBaseId: _knowledgeBase['id'],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            kbState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : UnitsListView(units: kbState.units),
          ],
        ),
      ),
    );
  }
}
