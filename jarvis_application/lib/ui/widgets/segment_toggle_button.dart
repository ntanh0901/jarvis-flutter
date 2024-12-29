import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider for managing the controller
final segmentControllerProvider =
    Provider.family<ValueNotifier<String>, String>((ref, initialSegment) {
  return ValueNotifier<String>(initialSegment);
});

// SegmentToggleButton widget
class SegmentToggleButton extends ConsumerStatefulWidget {
  final String initialSegment;
  final Map<String, String> segments;
  final void Function(String selectedSegment)? onSegmentChanged;

  const SegmentToggleButton({
    super.key,
    required this.initialSegment,
    required this.segments,
    this.onSegmentChanged,
  });

  @override
  _SegmentToggleButtonState createState() => _SegmentToggleButtonState();
}

class _SegmentToggleButtonState extends ConsumerState<SegmentToggleButton> {
  late ValueNotifier<String> controller;

  @override
  void initState() {
    super.initState();
    controller = ref.read(segmentControllerProvider(widget.initialSegment));

    // Add the listener only once
    controller.addListener(() {
      if (widget.onSegmentChanged != null) {
        widget.onSegmentChanged!(controller.value);
      }
    });
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedSegment(
      segments: widget.segments,
      controller: controller,
      activeStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      inactiveStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xFFf1f2f3),
      sliderColor: Colors.black,
      borderRadius: BorderRadius.circular(20),
      itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}
