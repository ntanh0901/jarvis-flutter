import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/ai_bot_provider.dart';
import 'create_assistant_dialog.dart';

class AssistantItem extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String instructions;
  final String createdAt;
  final VoidCallback? onTap;

  const AssistantItem({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.createdAt,
    this.onTap,
  });

  Future<void> _deleteAssistant(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final aiAssistantProviderNotifier = ref.read(aiAssistantProvider.notifier);
    aiAssistantProviderNotifier.removeAssistantById(id);

    try {
      await aiAssistantProviderNotifier.deleteAIAssistant(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted assistant "$name" successfully.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete assistant "$name".'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
      aiAssistantProviderNotifier.reAddAssistant(
        id: id,
        name: name,
        description: description,
        instructions: instructions,
        createdAt: createdAt,
      );
    }
  }

  Future<void> _editAssistant(BuildContext context, WidgetRef ref) async {
    final aiAssistantProviderNotifier = ref.read(aiAssistantProvider.notifier);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateAssistantDialog(
          title: 'Update Assistant',
          initialName: name,
          initialInstructions: instructions,
          initialDescription: description,
          onUpdate:
              (updatedName, updatedInstructions, updatedDescription) async {
            aiAssistantProviderNotifier.updateAssistantLocally(
              id: id,
              name: updatedName,
              instructions: updatedInstructions,
              description: updatedDescription,
            );

            try {
              await aiAssistantProviderNotifier.updateAIAssistant(
                id: id,
                name: updatedName,
                instructions: updatedInstructions,
                description: updatedDescription,
              );

              await aiAssistantProviderNotifier.fetchAIAssistants();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update assistant "$updatedName".'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMM dd, yyyy').format(DateTime.parse(createdAt));
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            elevation: 0, // Flat design
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Modern Avatar
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/bot_alpha.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title and Description
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              if (description.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Action Buttons
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.grey,
                              ),
                              onPressed: () => _editAssistant(context, ref),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: () => _deleteAssistant(context, ref),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Date
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
