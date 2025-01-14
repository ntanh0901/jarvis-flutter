import 'package:flutter/material.dart';
import 'package:jarvis_application/data/models/assistant.dart';

class AIModelDropdown extends StatelessWidget {
  final List<Assistant> assistants;
  final Assistant? selectedAssistant;
  final ValueChanged<Assistant?> onAssistantSelected;

  const AIModelDropdown({
    super.key,
    required this.assistants,
    required this.selectedAssistant,
    required this.onAssistantSelected,
  });

  void _showAssistantSelectionDialog(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: assistants.map((assistant) {
        final isSelected = assistant == selectedAssistant;

        return PopupMenuItem<Assistant>(
          value: assistant,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          assistant.imagePath,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        assistant.dto.name,
                        style: const TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        onAssistantSelected(assistant);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  if (isSelected)
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        onAssistantSelected(null);
                        Navigator.of(context).pop();
                      },
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      color: Colors.white,
    ).then((selected) {
      if (selected is Assistant) {
        onAssistantSelected(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedAssistant != null)
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      selectedAssistant!.imagePath,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedAssistant!.dto.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              )
            else
              const Text(
                'Select AI Model',
                style: TextStyle(fontSize: 14),
              ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => _showAssistantSelectionDialog(context),
              child: const Icon(Icons.arrow_drop_down, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
