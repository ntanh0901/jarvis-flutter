import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create an auto-dispose family provider instead of a regular StateProvider.family
final searchTextProviderFamily =
    StateProvider.autoDispose.family<String, String>((ref, id) => '');

class SearchTextField extends ConsumerStatefulWidget {
  final ValueChanged<String>? onChange;
  final String id;

  const SearchTextField({
    super.key,
    required this.id,
    this.onChange,
  });

  @override
  ConsumerState<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends ConsumerState<SearchTextField> {
  late TextEditingController _controller;

  AutoDisposeStateProvider<String> get _textProvider =>
      searchTextProviderFamily(widget.id);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(_textProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = ref.watch(_textProvider);
    final textNotifier = ref.read(_textProvider.notifier);

    if (_controller.text != text) {
      _controller.text = text;
      _controller.selection = TextSelection.collapsed(offset: text.length);
    }

    return TextField(
      controller: _controller,
      onChanged: (value) {
        textNotifier.state = value;
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD1D1D1),
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
                onPressed: () {
                  textNotifier.state = '';
                  if (widget.onChange != null) {
                    widget.onChange!('');
                  }
                },
                color: Colors.grey,
                iconSize: 20.0,
              )
            : null,
      ),
    );
  }
}
