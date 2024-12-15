// lib/widgets/containers.dart

import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final bool isLargeScreen;

  const GradientContainer({
    required this.child,
    required this.isLargeScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLargeScreen
          ? const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              ),
            )
          : null,
      child: child,
    );
  }
}

class CardContainer extends StatelessWidget {
  final Widget child;
  final bool isLargeScreen;
  final double width;
  final EdgeInsetsGeometry padding;

  const CardContainer({
    required this.child,
    required this.isLargeScreen,
    required this.width,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: isLargeScreen
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            )
          : null,
      child: child,
    );
  }
}
