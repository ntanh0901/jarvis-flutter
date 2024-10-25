import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ChatScreenStyles {
  static const Color iconColor = Colors.grey;
  static const double iconSize = 24.0;
  static const EdgeInsets inputContainerPadding =
      EdgeInsets.fromLTRB(8, 16, 8, 8);

  static const TextStyle maxImagesReachedStyle = TextStyle(color: Colors.red);
  static const Color removeImageButtonIconColor = Colors.white;

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

  // style for flushbar
  static EdgeInsets get centeredFlushbarMargin =>
      const EdgeInsets.symmetric(horizontal: 40, vertical: 10);

  static BorderRadius get centeredFlushbarBorderRadius =>
      BorderRadius.circular(8);

  static FlushbarPosition get centeredFlushbarPosition => FlushbarPosition.TOP;

  static TextStyle get flushbarTextStyle => const TextStyle(
        color: Colors.white,
        fontSize: 16,
      );

  static Flushbar createCenteredFlushbar({
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 2),
    IconData? icon,
    Color iconColor = Colors.white,
  }) {
    return Flushbar(
        duration: duration,
        backgroundColor: backgroundColor,
        margin: centeredFlushbarMargin,
        borderRadius: centeredFlushbarBorderRadius,
        flushbarPosition: centeredFlushbarPosition,
        messageText: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: flushbarTextStyle,
              ),
            ),
          ],
        ));
  }
}

class FlushbarStyle {
  const FlushbarStyle({
    required this.margin,
    required this.borderRadius,
    required this.flushbarPosition,
  });

  final BorderRadius borderRadius;
  final FlushbarPosition flushbarPosition;
  final EdgeInsets margin;

  Map<String, dynamic> toMap() {
    return {
      'margin': margin,
      'borderRadius': borderRadius,
      'flushbarPosition': flushbarPosition,
    };
  }
}
