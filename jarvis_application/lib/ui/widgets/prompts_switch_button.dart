import 'package:flutter/material.dart';

class PromptsSwitchButton extends StatelessWidget {
  final bool isMyPromptSelected;
  final VoidCallback onMyPromptSelected;
  final VoidCallback onPublicPromptSelected;

  const PromptsSwitchButton({
    super.key,
    required this.isMyPromptSelected,
    required this.onMyPromptSelected,
    required this.onPublicPromptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: const <ButtonSegment>[
        ButtonSegment(
          value: 'my_prompt',
          label: Text('My Prompt'),
        ),
        ButtonSegment(
          value: 'public_prompt',
          label: Text('Public Prompt'),
        ),
      ],
      selected: {isMyPromptSelected ? 'my_prompt' : 'public_prompt'},
      onSelectionChanged: (Set<dynamic> selected) {
        if (selected.contains('my_prompt')) {
          onMyPromptSelected();
        } else {
          onPublicPromptSelected();
        }
      },
      showSelectedIcon: false,
    );
  }
}