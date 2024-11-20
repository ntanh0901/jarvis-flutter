import 'package:flutter/material.dart';

class GoogleAuthButton extends StatelessWidget {
  final String label; // Customizable label text
  final VoidCallback onPressed; // Action for button press

  const GoogleAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        'assets/google_icon.png',
        height: 24,
        width: 24,
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black87),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}
