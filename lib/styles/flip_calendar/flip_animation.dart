import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A flip animation widget that performs a 3D card-flip transition
/// between two child widgets using AnimationController-based 3D transforms.
class FlipAnimationWidget extends StatefulWidget {
  final Widget frontChild;
  final Widget backChild;
  final Duration duration;
  final Axis flipDirection;
  final VoidCallback? onFlipComplete;

  /// Set to true to trigger the flip.
  final bool showBack;

  const FlipAnimationWidget({
    super.key,
    required this.frontChild,
    required this.backChild,
    this.duration = const Duration(milliseconds: 500),
    this.flipDirection = Axis.horizontal,
    this.onFlipComplete,
    this.showBack = false,
  });

  @override
  State<FlipAnimationWidget> createState() => _FlipAnimationWidgetState();
}

class _FlipAnimationWidgetState extends State<FlipAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFlipComplete?.call();
      }
    });

    // Listener to toggle which side is shown at the midpoint
    _animation.addListener(() {
      final isFront = _animation.value < math.pi / 2;
      if (_showFront != isFront) {
        setState(() => _showFront = isFront);
      }
    });

    if (widget.showBack) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant FlipAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBack != oldWidget.showBack) {
      if (widget.showBack) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse(from: math.pi);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Programmatically trigger a flip.
  void flip() {
    if (_controller.isAnimating) return;
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      listenable: _animation,
      builder: (context, _) {
        final angle = _animation.value;
        final isHorizontal = widget.flipDirection == Axis.horizontal;

        // The back face needs to be pre-rotated by pi so it reads correctly
        // when the flip brings it into view.
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001); // perspective

        if (isHorizontal) {
          transform.rotateY(_showFront ? angle : angle - math.pi);
        } else {
          transform.rotateX(_showFront ? angle : angle - math.pi);
        }

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: _showFront ? widget.frontChild : widget.backChild,
        );
      },
    );
  }
}

/// A self-contained flip panel that flips between old and new content
/// with a split-flap (departure board) style animation.
class SplitFlapWidget extends StatefulWidget {
  final Widget topChild;
  final Widget bottomChild;
  final Duration duration;

  const SplitFlapWidget({
    super.key,
    required this.topChild,
    required this.bottomChild,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<SplitFlapWidget> createState() => _SplitFlapWidgetState();
}

class _SplitFlapWidgetState extends State<SplitFlapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didUpdateWidget(covariant SplitFlapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger animation when children change
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      listenable: _controller,
      builder: (context, _) {
        final progress = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutBack,
        ).value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top half
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.5,
                child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateX(progress < 0.5 ? -progress * math.pi : 0),
                  child: progress < 0.5 ? widget.topChild : widget.bottomChild,
                ),
              ),
            ),
            const SizedBox(height: 1),
            // Bottom half
            ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.5,
                child: Transform(
                  alignment: Alignment.topCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateX(
                        progress > 0.5 ? (1 - progress) * math.pi : 0),
                  child: progress > 0.5 ? widget.bottomChild : widget.topChild,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Helper animated builder.
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
  }) : super();

  @override
  Widget build(BuildContext context) => builder(context, null);
}
