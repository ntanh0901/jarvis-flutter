import 'package:flutter/material.dart';

class AIModelDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> aiModels;
  final Map<String, dynamic>? selectedModel;
  final ValueChanged<Map<String, dynamic>> onModelSelected;

  const AIModelDropdown({
    Key? key,
    required this.aiModels,
    required this.selectedModel,
    required this.onModelSelected,
  }) : super(key: key);

  void _showModelSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select AI Model'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: aiModels.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.asset(
                    aiModels[index]['icon'],
                    width: 24,
                    height: 24,
                  ),
                  title: Text(aiModels[index]['name']),
                  onTap: () {
                    onModelSelected(aiModels[index]); // Gửi dữ liệu về ChatPage
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
          onTap: () => _showModelSelectionDialog(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedModel?['icon'] != null)
                Image.asset(
                  selectedModel?['icon'] ?? '',
                  width: 24,
                  height: 24,
                ),
              const SizedBox(width: 8),
              Text(
                selectedModel?['name'] ?? 'Select Model',
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
