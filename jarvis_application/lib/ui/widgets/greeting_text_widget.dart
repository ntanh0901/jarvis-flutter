// lib/widgets/greeting_text_widget.dart
import 'package:flutter/material.dart';

class GreetingTextWidget extends StatelessWidget {
  const GreetingTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "How can I assist you today?",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
