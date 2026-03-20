import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// GitHub contribution graph style heatmap calendar.
/// Takes a Map<DateTime, int> of data and displays colored squares
/// with week/month labels and a legend.
class GitHubHeatmap extends StatelessWidget {
  final int year;
  final Map<DateTime, int> data;
  final Color baseColor;
  final int levels;
  final double cellSize;
  final double cellSpacing;
  final ValueChanged<DateTime>? onDayTap;

  const GitHubHeatmap({
    super.key,
    required this.year,
    required this.data,
    this.baseColor = const Color(0xFF4CAF50),
    this.levels = 5,
    this.cellSize = 12,
    this.cellSpacing = 2,
    this.onDayTap,
  });

  int _getValue(DateTime date) {
    for (final entry in data.entries) {
      if (CalendarDateUtils.isSameDay(entry.key, date)) {
        return entry.value;
      }
    }
    return 0;
  }

  int get _maxValue {
    if (data.isEmpty) return 1;
    int max = 0;
    for (final v in data.values) {
      if (v > max) max = v;
    }
    return max == 0 ? 1 : max;
  }

  Color _colorForValue(int value) {
    if (value == 0) return Colors.grey[200]!;
    final intensity = (value / _maxValue).clamp(0.0, 1.0);
    final level = (intensity * (levels - 1)).ceil();
    return Color.lerp(
      baseColor.withValues(alpha: 0.2),
      baseColor,
      level / (levels - 1),
    )!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDay = DateTime(year, 1, 1);
    final lastDay = DateTime(year, 12, 31);
    final totalDays = lastDay.difference(firstDay).inDays + 1;

    // Build weeks (columns). Each column is a week starting on Monday.
    final firstMonday = firstDay.subtract(
      Duration(days: (firstDay.weekday - 1) % 7),
    );

    // Calculate total weeks
    final totalWeeks =
        ((lastDay.difference(firstMonday).inDays) / 7).ceil() + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                '$totalDays 天活动数据',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const Spacer(),
              Text(
                '$year',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Month labels
        _buildMonthLabels(theme, firstMonday, totalWeeks),
        const SizedBox(height: 4),
        // Grid with weekday labels
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekday labels (Mon, Wed, Fri)
            _buildWeekdayLabels(theme),
            const SizedBox(width: 4),
            // Heatmap grid
            Expanded(child: _buildGrid(firstMonday, totalWeeks)),
          ],
        ),
        const SizedBox(height: 8),
        // Legend
        _buildLegend(theme),
      ],
    );
  }

  Widget _buildMonthLabels(ThemeData theme, DateTime firstMonday, int totalWeeks) {
    // Determine which week each month starts in
    final labels = <Widget>[];
    // Offset for weekday label column
    labels.add(const SizedBox(width: 28));

    int lastMonth = 0;
    final cellTotal = cellSize + cellSpacing;

    for (int w = 0; w < totalWeeks; w++) {
      final weekStart = firstMonday.add(Duration(days: w * 7));
      if (weekStart.year == year && weekStart.month != lastMonth) {
        lastMonth = weekStart.month;
        final label = CalendarDateUtils.monthName(weekStart.month);
        labels.add(
          SizedBox(
            width: cellTotal,
            child: Text(
              label.length > 2 ? label.substring(0, 2) : label,
              style: TextStyle(fontSize: 9, color: Colors.grey[600]),
            ),
          ),
        );
      } else {
        labels.add(SizedBox(width: cellTotal));
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: labels),
    );
  }

  Widget _buildWeekdayLabels(ThemeData theme) {
    const displayDays = [1, 3, 5]; // Mon, Wed, Fri
    return Column(
      children: List.generate(7, (i) {
        final wd = i + 1;
        return SizedBox(
          height: cellSize + cellSpacing,
          width: 24,
          child: displayDays.contains(wd)
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    CalendarDateUtils.weekdayName(wd),
                    style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                  ),
                )
              : null,
        );
      }),
    );
  }

  Widget _buildGrid(DateTime firstMonday, int totalWeeks) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(totalWeeks, (w) {
          return Column(
            children: List.generate(7, (d) {
              final date = firstMonday.add(Duration(days: w * 7 + d));
              final isInYear = date.year == year;
              final value = isInYear ? _getValue(date) : 0;
              final color = isInYear ? _colorForValue(value) : Colors.transparent;

              return GestureDetector(
                onTap: isInYear ? () => onDayTap?.call(date) : null,
                child: Tooltip(
                  message: isInYear
                      ? '${date.month}/${date.day}: $value'
                      : '',
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    margin: EdgeInsets.all(cellSpacing / 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                      border: isInYear
                          ? Border.all(
                              color: Colors.black.withValues(alpha: 0.05),
                              width: 0.5,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Less', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        const SizedBox(width: 4),
        ...List.generate(levels, (i) {
          final color = i == 0
              ? Colors.grey[200]!
              : Color.lerp(
                  baseColor.withValues(alpha: 0.2),
                  baseColor,
                  i / (levels - 1),
                )!;
          return Container(
            width: cellSize,
            height: cellSize,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text('More', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }
}
