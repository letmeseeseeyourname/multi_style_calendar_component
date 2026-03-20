import 'package:flutter/material.dart';

/// A red horizontal line with a leading circle dot that indicates the current
/// time position on the day timeline.
///
/// Should be placed inside a Stack whose height equals the full scrollable
/// day area.
class TimeIndicator extends StatelessWidget {
  /// Vertical offset from the top of the parent Stack (pre-calculated by the
  /// parent based on the current time).
  final double top;

  /// Width reserved for the time-label column; the indicator starts from this
  /// offset so it does not overlap the labels.
  final double timeColumnWidth;

  /// Colour of the line and dot.
  final Color color;

  const TimeIndicator({
    super.key,
    required this.top,
    this.timeColumnWidth = 56.0,
    this.color = const Color(0xFFE53935),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top - 4, // centre the dot vertically on the line
      left: timeColumnWidth - 6,
      right: 0,
      height: 10,
      child: Row(
        children: [
          // Leading circle dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          // Horizontal line
          Expanded(
            child: Container(
              height: 2,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
