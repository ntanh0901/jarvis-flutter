import 'package:flutter/material.dart';

class HoverTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const HoverTextButton({
    required this.text,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        padding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
        textStyle: const TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
        ),
      ),
      child: Text(text),
    );
  }
}
