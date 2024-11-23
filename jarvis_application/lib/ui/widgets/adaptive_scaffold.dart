import 'package:flutter/material.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const AdaptiveScaffold({
    super.key, 
    required this.child, 
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Tablet or desktop layout
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: Center(
                child: IntrinsicWidth(
                  stepWidth: 600,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                      minWidth: 400,
                    ),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          // Mobile layout
          return Scaffold(
            body: SafeArea(child: child),
          );
        }
      },
    );
  }
}
