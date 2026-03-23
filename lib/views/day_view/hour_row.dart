import 'package:flutter/material.dart';

/// A single hour row displaying a time label on the left and a horizontal
/// divider line spanning the remaining width.
///
/// Used as the background grid inside [DayView].
class HourRow extends StatelessWidget {
  /// The hour to display (0-23).
  final int hour;

  /// Vertical offset from the top of the parent Stack.
  final double top;

  /// Height of one hour slot.
  final double hourHeight;

  /// Width reserved for the time label column.
  final double timeColumnWidth;

  const HourRow({
    super.key,
    required this.hour,
    required this.top,
    this.hourHeight = 60.0,
    this.timeColumnWidth = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lineColor = theme.dividerColor.withValues(alpha: 0.3);
    final halfLineColor = theme.dividerColor.withValues(alpha: 0.15);

    return SizedBox(
      height: hourHeight,
      child: Stack(
        children: [
          // Full-hour line with label
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                SizedBox(
                  width: timeColumnWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _formatHour(hour),
                      textAlign: TextAlign.right,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container(height: 0.5, color: lineColor)),
              ],
            ),
          ),
          // Half-hour line
          Positioned(
            top: hourHeight / 2,
            left: timeColumnWidth,
            right: 0,
            child: Container(height: 0.5, color: halfLineColor),
          ),
        ],
      ),
    );
  }

  String _formatHour(int h) {
    final hour = h % 24;
    return '${hour.toString().padLeft(2, '0')}:00';
  }
}
