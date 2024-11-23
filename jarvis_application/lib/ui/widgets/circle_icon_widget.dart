// lib/widgets/circle_icon_widget.dart
import 'package:flutter/material.dart';

class CircleIconWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CircleIconWidget({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
