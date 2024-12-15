import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;

  const SearchTextField({super.key, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F2F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF6841EA),
            width: 1.0,
          ),
        ),
        hintText: 'Search',
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: const Icon(Icons.search),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
