import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final int imageType;

  const LogoWidget({super.key, required this.imageType});

  @override
  Widget build(BuildContext context) {

    final imagePath = imageType == 1
        ? 'assets/images/brain.jpg'
        : imageType == 2
        ? 'assets/images/bot_alpha.png'
        : 'assets/images/bot_beta.png';

    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.purpleAccent.withOpacity(0.1),
        radius: 50,
        child: ClipOval(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 80,
            height: 80,
          ),
        ),
      ),
    );
  }
}
