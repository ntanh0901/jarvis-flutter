import 'package:flutter/material.dart';
import 'ai_model_dropdown.dart';
import 'icon_buttons_row.dart';
import 'package:jarvis_application/data/models/assistant.dart';

class ActionRow extends StatelessWidget {
  final List<Assistant> assistants;
  final Assistant? selectedAssistant;
  final ValueChanged<Assistant> onAssistantSelected;
  final void Function(String action) onActionSelected;
  final int remainUsage;

  const ActionRow({
    Key? key,
    required this.assistants,
    required this.selectedAssistant,
    required this.onAssistantSelected,
    required this.onActionSelected,
    required this.remainUsage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmallScreen = constraints.maxWidth < 400;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: AIModelDropdown(
                        assistants: assistants,
                        selectedAssistant: selectedAssistant,
                        onAssistantSelected: onAssistantSelected,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    IconButtonsRow(
                      onIconPressed: onActionSelected, // Gửi lên ChatPage
                      remainUsage: remainUsage,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: AIModelDropdown(
                        assistants: assistants,
                        selectedAssistant: selectedAssistant,
                        onAssistantSelected: onAssistantSelected,
                      ),
                    ),
                    Expanded(
                      child: IconButtonsRow(
                        onIconPressed: onActionSelected, // Gửi lên ChatPage
                        remainUsage: remainUsage,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
