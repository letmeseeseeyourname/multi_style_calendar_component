import 'package:flutter/material.dart';

/// Vertical time ruler showing hour labels with horizontal divider lines.
class TimeRuler extends StatelessWidget {
  /// First hour to display (inclusive, 0-23).
  final int startHour;

  /// Last hour to display (exclusive, 1-24).
  final int endHour;

  /// Height per hour in logical pixels.
  final double hourHeight;

  /// Width of the time label column.
  final double width;

  /// Whether to show the current time indicator.
  final bool showCurrentTime;

  /// Color of the divider lines.
  final Color? lineColor;

  const TimeRuler({
    super.key,
    this.startHour = 0,
    this.endHour = 24,
    this.hourHeight = 60.0,
    this.width = 56.0,
    this.showCurrentTime = true,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalHours = endHour - startHour;
    final totalHeight = totalHours * hourHeight;
    final effectiveLineColor =
        lineColor ?? colorScheme.outlineVariant.withValues(alpha: 0.5);

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60;
    final endMinutes = endHour * 60;
    final isCurrentTimeVisible =
        showCurrentTime &&
        nowMinutes >= startMinutes &&
        nowMinutes < endMinutes;

    return SizedBox(
      width: width,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Hour labels and lines
          for (int i = 0; i <= totalHours; i++)
            Positioned(
              top: i * hourHeight,
              left: 0,
              right: 0,
              child: _HourRow(
                hour: startHour + i,
                lineColor: effectiveLineColor,
                width: width,
                isLast: i == totalHours,
              ),
            ),

          // Current time indicator
          if (isCurrentTimeVisible)
            Positioned(
              top: (nowMinutes - startMinutes) / 60.0 * hourHeight,
              left: 0,
              right: 0,
              child: _CurrentTimeIndicator(width: width),
            ),
        ],
      ),
    );
  }
}

class _HourRow extends StatelessWidget {
  final int hour;
  final Color lineColor;
  final double width;
  final bool isLast;

  const _HourRow({
    required this.hour,
    required this.lineColor,
    required this.width,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Don't show label for the last divider (endHour boundary)
    final label = (!isLast && hour <= 23)
        ? '${hour.toString().padLeft(2, '0')}:00'
        : '';

    return SizedBox(
      height: 0,
      child: OverflowBox(
        maxHeight: 20,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(
              width: width - 8,
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _CurrentTimeIndicator extends StatelessWidget {
  final double width;

  const _CurrentTimeIndicator({required this.width});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = colorScheme.error;

    return SizedBox(
      height: 0,
      child: OverflowBox(
        maxHeight: 12,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(width: width - 12),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(child: Container(height: 2, color: indicatorColor)),
          ],
        ),
      ),
    );
  }
}
