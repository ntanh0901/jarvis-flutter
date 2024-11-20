import 'package:flutter/material.dart';

class CustomTextFormFieldStyle {
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final BorderRadius borderRadius;
  final Color focusedBorderColor;
  final Color fillColor;

  const CustomTextFormFieldStyle({
    this.labelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.hintStyle = const TextStyle(
      color: Color(0xFF908F95),
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.focusedBorderColor = Colors.blue,
    this.fillColor = const Color(0xFFF5F4FA),
  });
}

class TextFormFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final CustomTextFormFieldStyle style;
  final FormFieldValidator<String>? validator;

  const TextFormFieldWidget({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.style = const CustomTextFormFieldStyle(),
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final InputDecoration decoration = InputDecoration(
      fillColor: style.fillColor,
      filled: true,
      hintText: hintText,
      hintStyle: style.hintStyle,
      border: OutlineInputBorder(
        borderRadius: style.borderRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: style.borderRadius,
        borderSide: BorderSide(
          color: style.focusedBorderColor,
          width: 2.0,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: style.labelStyle,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: decoration,
          validator: validator,
        ),
      ],
    );
  }
}
