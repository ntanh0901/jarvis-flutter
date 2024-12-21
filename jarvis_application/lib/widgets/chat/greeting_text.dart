import 'package:flutter/material.dart';

class GreetingText extends StatelessWidget {
  final String? assistantName; // Tham số mới để truyền tên Assistant

  const GreetingText({super.key, this.assistantName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          assistantName != null
              ? "Hello, I'm $assistantName. \n Nice to meet you!"
              : "How can I assist you today?",
          textAlign: TextAlign.center, // Canh giữa nội dung
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (assistantName != null) // Hiển thị câu hỏi phụ nếu có assistantName
          const Text(
            "How can I assist you today?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
      ],
    );
  }
}
