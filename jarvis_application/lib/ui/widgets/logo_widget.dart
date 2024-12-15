// lib/widgets/logo_widget.dart
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.purpleAccent.withOpacity(0.1),
        radius: 50,
        child: ClipOval(
          child: Image.asset(
            'assets/images/brain.jpg',
            fit: BoxFit.cover,
            width: 80,
            height: 80,
          ),
        ),
      ),
    );
  }
}
