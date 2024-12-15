import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;

  const SearchTextField({super.key, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Search',
        prefixIcon: Icon(Icons.search), // Add search icon
      ),
      onSubmitted: onSubmitted,
    );
  }
}
