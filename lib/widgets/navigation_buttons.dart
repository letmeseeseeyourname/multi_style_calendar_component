import 'package:flutter/material.dart';

/// A row of previous/next icon buttons for calendar navigation.
class NavigationButtons extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String? previousTooltip;
  final String? nextTooltip;
  final double iconSize;

  const NavigationButtons({
    super.key,
    required this.onPrevious,
    required this.onNext,
    this.previousTooltip,
    this.nextTooltip,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: Icon(Icons.chevron_left, size: iconSize),
          tooltip: previousTooltip ?? '上一页',
          style: IconButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onNext,
          icon: Icon(Icons.chevron_right, size: iconSize),
          tooltip: nextTooltip ?? '下一页',
          style: IconButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
