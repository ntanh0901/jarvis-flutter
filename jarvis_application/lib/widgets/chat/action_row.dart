import 'package:flutter/material.dart';
import 'ai_model_dropdown.dart';
import 'icon_buttons_row.dart';

class ActionRow extends StatelessWidget {
  final List<Map<String, dynamic>> aiModels;
  final Map<String, dynamic>? selectedModel;
  final ValueChanged<Map<String, dynamic>> onModelSelected;
  final void Function(String action) onActionSelected;

  const ActionRow({
    Key? key,
    required this.aiModels,
    required this.selectedModel,
    required this.onModelSelected,
    required this.onActionSelected,
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
                  aiModels: aiModels,
                  selectedModel: selectedModel,
                  onModelSelected: onModelSelected,
                ),
              ),
              const SizedBox(height: 8.0),
              IconButtonsRow(
                onIconPressed: onActionSelected, // Gửi lên ChatPage
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 120,
                child: AIModelDropdown(
                  aiModels: aiModels,
                  selectedModel: selectedModel,
                  onModelSelected: onModelSelected,
                ),
              ),
              Expanded(
                child: IconButtonsRow(
                  onIconPressed: onActionSelected, // Gửi lên ChatPage
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
