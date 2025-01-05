import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomFormBuilderTextField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hintText;
  final List<String? Function(String?)> validators;
  final Function(String?)? onChanged;
  final bool isPasswordField;

  const CustomFormBuilderTextField({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.validators = const [],
    this.onChanged,
    this.isPasswordField = false,
  });

  @override
  Widget build(BuildContext context) {
    final obscureTextNotifier = ValueNotifier<bool>(isPasswordField);

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
        ValueListenableBuilder<bool>(
          valueListenable: obscureTextNotifier,
          builder: (context, obscureText, child) {
            return FormBuilderTextField(
              name: name,
              onChanged: onChanged,
              obscureText: obscureText,
              validator: FormBuilderValidators.compose(validators),
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                ),
                suffixIcon: isPasswordField
                    ? IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          obscureTextNotifier.value =
                              !obscureTextNotifier.value;
                        },
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
