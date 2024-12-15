import 'package:flutter/material.dart';

class CustomInputDecorator extends StatelessWidget {
  final Widget child;

  const CustomInputDecorator({
    super.key,
    required this.child,
  });

  static InputDecoration baseDecoration = InputDecoration(
    hintStyle: const TextStyle(color: Color(0xFF908F95)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
    labelStyle: const TextStyle(color: Colors.black),
  );

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: baseDecoration,
      child: child,
    );
  }
}
