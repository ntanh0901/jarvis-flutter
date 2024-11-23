import 'package:flutter/material.dart';

import '../../models/assistant.dart';

class AIModelDropdown extends StatelessWidget {
  final List<Assistant> assistants;
  final Assistant? selectedAssistant;
  final ValueChanged<Assistant> onAssistantSelected;

  const AIModelDropdown({
    Key? key,
    required this.assistants,
    required this.selectedAssistant,
    required this.onAssistantSelected,
  }) : super(key: key);

  void _showAssistantSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Assistant'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: assistants.length,
              itemBuilder: (BuildContext context, int index) {
                final assistant = assistants[index];
                return ListTile(
                  leading: Image.asset(
                    assistant.imagePath,
                    width: 24,
                    height: 24,
                  ),
                  title: Text(assistant.dto.name),
                  subtitle: Text(assistant.dto.model.toString()),
                  onTap: () {
                    onAssistantSelected(assistant); // Truyền Assistant đã chọn
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => _showAssistantSelectionDialog(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedAssistant != null)
                Image.asset(
                  selectedAssistant!.imagePath,
                  width: 24,
                  height: 24,
                ),
              const SizedBox(width: 8),
              Text(
                selectedAssistant?.dto.name ?? 'Select Assistant',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
