import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String middleText;

  const CustomDivider({required this.middleText, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xffd9dade),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            middleText,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xffd9dade),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
