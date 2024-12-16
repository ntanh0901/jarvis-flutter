import 'package:flutter/material.dart';

class Chips extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<String> onItemSelected;

  const Chips({
    required this.items,
    required this.selectedItems,
    required this.onItemSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 0.0,
      children: items.map((String category) {
        final isSelected = selectedItems.contains(category);
        return InputChip(
          label: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedColor: Colors.black,
          backgroundColor: const Color(0xFFF1F2F3),
          onSelected: (bool selected) {
            onItemSelected(category);
          },
          showCheckmark: false,
          deleteIcon: null,
          padding: const EdgeInsets.all(4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(style: BorderStyle.none),
          ),
        );
      }).toList(),
    );
  }
}
