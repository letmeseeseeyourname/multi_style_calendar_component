import 'package:flutter/material.dart';

/// Timeline background with horizontal hour lines for the week/day views.
///
/// Renders hour labels on the left and dashed grid lines across the full width.
class WeekTimeline extends StatelessWidget {
  /// The first visible hour (inclusive).
  final int startHour;

  /// The last visible hour (exclusive).
  final int endHour;

  /// Height in logical pixels for each one-hour slot.
  final double hourHeight;

  /// Width of the time-label column on the left side.
  final double timeColumnWidth;

  const WeekTimeline({
    super.key,
    this.startHour = 0,
    this.endHour = 24,
    this.hourHeight = 60.0,
    this.timeColumnWidth = 56.0,
  });

  int get _totalHours => endHour - startHour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lineColor = theme.dividerColor.withValues(alpha: 0.3);
    final halfLineColor = theme.dividerColor.withValues(alpha: 0.15);

    return SizedBox(
      height: _totalHours * hourHeight,
      child: Stack(
        children: [
          // Hour lines and half-hour lines
          for (int i = 0; i <= _totalHours; i++) ...[
            // Full hour line
            Positioned(
              top: i * hourHeight,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  // Time label
                  SizedBox(
                    width: timeColumnWidth,
                    child: i < _totalHours
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              _formatHour(startHour + i),
                              textAlign: TextAlign.right,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  // Horizontal line
                  Expanded(child: Container(height: 0.5, color: lineColor)),
                ],
              ),
            ),
            // Half-hour line (skip last)
            if (i < _totalHours)
              Positioned(
                top: i * hourHeight + hourHeight / 2,
                left: timeColumnWidth,
                right: 0,
                child: Container(height: 0.5, color: halfLineColor),
              ),
          ],
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    final h = hour % 24;
    return '${h.toString().padLeft(2, '0')}:00';
  }
}
