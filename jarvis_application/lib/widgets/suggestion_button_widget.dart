// lib/widgets/suggestion_button_widget.dart
import 'package:flutter/material.dart';

class SuggestionButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SuggestionButtonWidget({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(text),
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
