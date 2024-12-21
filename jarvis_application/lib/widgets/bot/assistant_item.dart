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

  const AssistantItem({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.createdAt,
  }) : super(key: key);

  Future<void> _deleteAssistant(BuildContext context, WidgetRef ref) async {
    final aiAssistantProviderNotifier = ref.read(aiAssistantProvider.notifier);

    // delete assistant locally
    aiAssistantProviderNotifier.removeAssistantById(id);

    try {
      // Gửi yêu cầu xóa tới server
      await aiAssistantProviderNotifier.deleteAIAssistant(id);

      // display success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted assistant "$name" successfully.')),
      );
    } catch (e) {
      // display error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete assistant "$name".')),
      );
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

    // Hiển thị hộp thoại CreateAssistantDialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateAssistantDialog(
          title: 'Update Assistant',
          initialName: name,
          initialInstructions: instructions ?? '', // Truyền instructions vào đây
          initialDescription: description ?? '',
          onUpdate: (updatedName, updatedInstructions, updatedDescription) async {

            // update assistant locally
            aiAssistantProviderNotifier.updateAssistantLocally(
              id: id,
              name: updatedName,
              instructions: updatedInstructions,
              description: updatedDescription,
            );


            try {
              // send HTTP PATCH request
              await aiAssistantProviderNotifier.updateAIAssistant(
                id: id,
                name: updatedName,
                instructions: updatedInstructions,
                description: updatedDescription,
              );

              // display success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Updated assistant "$updatedName" successfully.')),
              );

              // update the list of assistants
              await aiAssistantProviderNotifier.fetchAIAssistants();
            } catch (e) {
              // display error snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update assistant "$updatedName".')),
              );
            }
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.parse(createdAt));

    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/bot_alpha.png'),
                radius: 30,
              ),
              title: Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description != null) Text(description!),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                      onPressed: () {
                        _editAssistant(context, ref);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {
                        _deleteAssistant(context, ref);
                      },
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
