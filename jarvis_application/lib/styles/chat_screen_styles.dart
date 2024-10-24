import 'package:flutter/material.dart';

class ChatScreenStyles {
  static const Color iconColor = Colors.grey;
  static const double iconSize = 24.0;

  static BoxDecoration inputContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, -1),
        ),
      ],
    );
  }

  static const EdgeInsets inputContainerPadding =
      EdgeInsets.fromLTRB(8, 16, 8, 8);

  static const TextStyle maxImagesReachedStyle = TextStyle(color: Colors.red);
  static BoxDecoration removeImageButtonDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.grey.withOpacity(0.5),
      shape: BoxShape.circle,
      border: Border.all(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: 1,
      ),
    );
  }

  static const Color removeImageButtonIconColor = Colors.white;
}
