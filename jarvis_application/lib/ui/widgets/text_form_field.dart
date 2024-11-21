import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomFormBuilderTextField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hintText;
  final List<String? Function(String?)> validators;
  final Function(String?)? onChanged;
  final TextInputType keyboardType;

  const CustomFormBuilderTextField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.validators = const [],
    this.onChanged,
    this.keyboardType = TextInputType.text, // Default to text input
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 8),
        ],
        FormBuilderTextField(
          name: name,
          onChanged: onChanged,
          keyboardType: keyboardType,
          validator: FormBuilderValidators.compose(validators),
          decoration: InputDecoration(
            hintText: hintText,
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
          ),
        ),
      ],
    );
  }
}
