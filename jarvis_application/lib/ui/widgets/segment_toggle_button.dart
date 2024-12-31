import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class to hold segment state
class SegmentState extends StateNotifier<String> {
  SegmentState(String initialValue) : super(initialValue);

  void updateSegment(String newValue) {
    state = newValue;
  }
}

// Provider for creating unique state for each instance
final segmentStateProvider = StateNotifierProvider.autoDispose
    .family<SegmentState, String, String>((ref, initialSegment) {
  return SegmentState(initialSegment);
});

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
  late ValueNotifier<String> _controller;

  @override
  void initState() {
    super.initState();
    // Create a local ValueNotifier for this instance
    _controller = ValueNotifier<String>(widget.initialSegment);

    // Add listener for callbacks
    _controller.addListener(_handleValueChange);
  }

  void _handleValueChange() {
    // Update the state
    ref
        .read(segmentStateProvider(widget.initialSegment).notifier)
        .updateSegment(_controller.value);

    // Call the callback if provided
    widget.onSegmentChanged?.call(_controller.value);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleValueChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state for this specific instance
    final currentSegment =
        ref.watch(segmentStateProvider(widget.initialSegment));

    // Update controller value if it doesn't match the state
    if (_controller.value != currentSegment) {
      _controller.value = currentSegment;
    }

    return AdvancedSegment(
      segments: widget.segments,
      controller: _controller,
      activeStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      inactiveStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xFFf1f2f3),
      sliderColor: const Color(0xFF6366F1),
      borderRadius: BorderRadius.circular(20),
      itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }
}
