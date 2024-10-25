// lib/widgets/chat_input_widget.dart
import 'package:flutter/material.dart';

class ChatInputWidget extends StatelessWidget {
  final VoidCallback? onSend;

  const ChatInputWidget({this.onSend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend ?? () {},
          ),
        ],
      ),
    );
  }
}
