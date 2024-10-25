import 'package:flutter/material.dart';

class CustomInputDecorator extends StatelessWidget {
  final Widget child;
  final String hintText;
  final Widget? suffixIcon;

  const CustomInputDecorator({
    super.key,
    required this.child,
    required this.hintText,
    this.suffixIcon,
  });

  static InputDecoration baseDecoration = InputDecoration(
    hintStyle: const TextStyle(color: Color(0xFF908F95)),
    filled: true,
    fillColor: const Color(0xFFF5F4FA),
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
      decoration: baseDecoration.copyWith(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      child: child,
    );
  }
}
