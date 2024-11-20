import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size; // Size for the CircleAvatar and text

  const AppLogo({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: size, // Set the radius using the provided size
          backgroundImage: const AssetImage('assets/app_circle_icon.png'),
        ),
        const SizedBox(width: 10),
        Text(
          'Jarvis',
          style: TextStyle(
            fontSize: size * 1.25, // Font size can be proportionally larger
            color: const Color(0xff1450a3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
