import 'package:flutter/material.dart';
import 'package:jarvis_application/data/models/assistant.dart';

import 'ai_model_dropdown.dart';
import 'icon_buttons_row.dart';

class ActionRow extends StatelessWidget {
  final List<Assistant> assistants;
  final Assistant? selectedAssistant;
  final ValueChanged<Assistant> onAssistantSelected;
  final void Function(String action) onActionSelected;
  final int remainUsage;

  const ActionRow({
    super.key,
    required this.assistants,
    required this.selectedAssistant,
    required this.onAssistantSelected,
    required this.onActionSelected,
    required this.remainUsage,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AIModelDropdown(
                assistants: assistants,
                selectedAssistant: selectedAssistant,
                onAssistantSelected: onAssistantSelected,
              ),
              const SizedBox(height: 3.0),
              IconButtonsRow(
                onIconPressed: onActionSelected,
                remainUsage: remainUsage,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 18,
        onPressed: () => onActionSelected(action), // Gửi action đến ActionRow
      ),
    );
  }
}
