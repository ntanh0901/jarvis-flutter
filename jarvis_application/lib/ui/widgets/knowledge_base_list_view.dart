import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../views/knowledgeBase/knowledge_base_config_screen.dart';
import '../../data/models/knowledge_base.dart';
import '../../ui/viewmodels/knowledge_base_viewmodel.dart';

class KnowledgeBaseListView extends ConsumerWidget {
  final List<KnowledgeResDto> knowledgeBases;

  const KnowledgeBaseListView({
    required this.knowledgeBases,
    super.key,
  });

  String _formatSize(int sizeInBytes) {
    final sizeInMB = sizeInBytes / (1024 * 1024);
    return '${sizeInMB.toStringAsFixed(1)}MB';
  }

  Future<void> _deleteKnowledgeBase(
      BuildContext context, WidgetRef ref, String id) async {
    try {
      await ref.read(kbViewModelProvider.notifier).deleteKnowledgeBase(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Knowledge base deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting knowledge base: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: knowledgeBases.length,
      itemBuilder: (context, index) {
        final knowledgeBase = knowledgeBases[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.blue, // Background color for the icon
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: const Icon(
              Icons.storage_rounded,
              color: Colors.white, // Icon color
            ),
          ),
          title: Text(knowledgeBase.knowledgeName),
          subtitle: Text(knowledgeBase.description), // Add description text
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KnowledgeBaseConfiguration(
                  knowledgeBase: {
                    'id': knowledgeBase.id,
                    'icon': Icons.storage_rounded,
                    'name': knowledgeBase.knowledgeName,
                    'description': knowledgeBase.description,
                    'units': knowledgeBase
                        .numUnits, // Replace with actual units if available
                    'size': knowledgeBase
                        .totalSize, // Replace with actual size if available
                    'editTime':
                        knowledgeBase.updatedAt?.toIso8601String() ?? 'N/A',
                  },
                ),
              ),
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(knowledgeBase.knowledgeName),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align items to the left
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Units: ${knowledgeBase.numUnits}'), // Replace with actual units if available
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Size: ${_formatSize(knowledgeBase.totalSize ?? 0)}'), // Replace with actual size if available
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  'Last Edited: ${knowledgeBase.updatedAt?.toIso8601String() ?? 'N/A'}'),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteKnowledgeBase(context, ref, knowledgeBase.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
