import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a StateProvider for managing the text field state
final searchTextProvider = StateProvider<String>((ref) => '');

class SearchTextField extends ConsumerWidget {
  final ValueChanged<String>? onChanged;

  const SearchTextField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(searchTextProvider);
    final textNotifier = ref.read(searchTextProvider.notifier);

    return TextField(
      controller: TextEditingController(text: text)
        ..selection = TextSelection.collapsed(offset: text.length),
      onChanged: (value) {
        textNotifier.state = value;
        if (onChanged != null) {
          onChanged!(value);
        }
      },
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
        suffixIcon: text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => textNotifier.state = '',
                color: Colors.grey,
                iconSize: 20.0,
              )
            : null,
      ),
    );
  }
}
