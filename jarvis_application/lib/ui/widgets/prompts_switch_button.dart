import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';

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
    final ValueNotifier<String> controller = ValueNotifier<String>(
      isMyPromptSelected ? 'my_prompt' : 'public_prompt',
    );

    // Listen to changes in the controller
    controller.addListener(() {
      final selectedValue = controller.value;
      if (selectedValue == 'my_prompt') {
        onMyPromptSelected();
      } else if (selectedValue == 'public_prompt') {
        onPublicPromptSelected();
      }
    });

    return AdvancedSegment(
      segments: const {
        'my_prompt': 'My Prompt',
        'public_prompt': 'Public Prompt',
      },
      controller: controller,
      activeStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      inactiveStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xFFf1f2f3),
      sliderColor: Colors.black,
      borderRadius: BorderRadius.circular(20),
      itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}
