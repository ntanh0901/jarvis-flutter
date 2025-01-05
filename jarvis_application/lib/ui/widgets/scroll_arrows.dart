import 'package:flutter/material.dart';

class ScrollArrows extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onScrollToBottom;

  const ScrollArrows({
    super.key,
    required this.scrollController,
    required this.onScrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _ScrollPositionNotifier(scrollController),
      builder: (context, arrowsState, child) {
        if (!arrowsState.showAnyArrows) return const SizedBox.shrink();

        return Positioned(
          right: 16,
          bottom: 120,
          child: Column(
            children: [
              if (arrowsState.showUpArrow && arrowsState.isScrollingUp)
                _ScrollButton(
                  icon: Icons.arrow_upward,
                  onPressed: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              if (arrowsState.showUpArrow &&
                  arrowsState.showDownArrow &&
                  arrowsState.isScrollingUp &&
                  arrowsState.isScrollingDown)
                const SizedBox(height: 8),
              if (arrowsState.showDownArrow && arrowsState.isScrollingDown)
                _ScrollButton(
                  icon: Icons.arrow_downward,
                  onPressed: onScrollToBottom,
                ),
            ],
          ),
        );
      },
    );
  }
}

class ScrollArrowsState {
  final bool showUpArrow;
  final bool showDownArrow;
  final bool isScrollingUp;
  final bool isScrollingDown;

  ScrollArrowsState({
    required this.showUpArrow,
    required this.showDownArrow,
    required this.isScrollingUp,
    required this.isScrollingDown,
  });

  bool get showAnyArrows =>
      (showUpArrow && isScrollingUp) || (showDownArrow && isScrollingDown);
}

class _ScrollPositionNotifier extends ValueNotifier<ScrollArrowsState> {
  final ScrollController scrollController;
  double _lastScrollPosition = 0;
  bool _isScrollingUp = false;
  bool _isScrollingDown = false;
  DateTime _lastScrollUpdate = DateTime.now();

  _ScrollPositionNotifier(this.scrollController)
      : super(ScrollArrowsState(
          showUpArrow: false,
          showDownArrow: false,
          isScrollingUp: false,
          isScrollingDown: false,
        )) {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final currentScroll = scrollController.position.pixels;
    final maxScroll = scrollController.position.maxScrollExtent;
    final distanceFromBottom = maxScroll - currentScroll;
    final distanceFromTop = currentScroll;

    // Determine scroll direction
    final now = DateTime.now();
    if (now.difference(_lastScrollUpdate) > const Duration(milliseconds: 100)) {
      _isScrollingUp = currentScroll < _lastScrollPosition;
      _isScrollingDown = currentScroll > _lastScrollPosition;
      _lastScrollPosition = currentScroll;
      _lastScrollUpdate = now;
    }

    // Auto-hide arrows after a delay if no scrolling
    Future.delayed(const Duration(seconds: 2), () {
      if (now == _lastScrollUpdate) {
        _isScrollingUp = false;
        _isScrollingDown = false;
        _updateState(distanceFromTop, distanceFromBottom);
      }
    });

    _updateState(distanceFromTop, distanceFromBottom);
  }

  void _updateState(double distanceFromTop, double distanceFromBottom) {
    const threshold = 100.0;

    // Determine which arrows to show
    final showUpArrow = distanceFromTop > threshold;
    final showDownArrow = distanceFromBottom > threshold;

    // Update state if changed
    final newState = ScrollArrowsState(
      showUpArrow: showUpArrow,
      showDownArrow: showDownArrow,
      isScrollingUp: _isScrollingUp,
      isScrollingDown: _isScrollingDown,
    );

    if (value.showUpArrow != newState.showUpArrow ||
        value.showDownArrow != newState.showDownArrow ||
        value.isScrollingUp != newState.isScrollingUp ||
        value.isScrollingDown != newState.isScrollingDown) {
      value = newState;
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}

class _ScrollButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ScrollButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          icon: Icon(
            icon,
            size: 18,
          ),
          onPressed: onPressed,
          color: Colors.blue,
          tooltip:
              icon == Icons.arrow_upward ? 'Scroll to top' : 'Scroll to bottom',
        ),
      ),
    );
  }
}
