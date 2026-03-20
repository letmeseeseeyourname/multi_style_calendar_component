import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/color_schemes.dart';

/// Activity heatmap variant with customizable colors and date range.
/// Unlike the GitHub heatmap which is year-based, this supports
/// arbitrary date ranges and multiple color schemes.
class ActivityHeatmap extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Map<DateTime, int> data;
  final List<Color>? colorStops;
  final String? title;
  final double cellSize;
  final double cellSpacing;
  final bool showMonthLabels;
  final bool showWeekdayLabels;
  final ValueChanged<DateTime>? onDayTap;

  const ActivityHeatmap({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.data,
    this.colorStops,
    this.title,
    this.cellSize = 14,
    this.cellSpacing = 2,
    this.showMonthLabels = true,
    this.showWeekdayLabels = true,
    this.onDayTap,
  });

  List<Color> get _colors =>
      colorStops ??
      [
        Colors.grey[200]!,
        const Color(0xFFB2DFDB),
        const Color(0xFF4DB6AC),
        const Color(0xFF00897B),
        const Color(0xFF004D40),
      ];

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
    if (value == 0) return _colors.first;
    final levels = _colors.length;
    final normalized = (value / _maxValue).clamp(0.0, 1.0);
    final idx = (normalized * (levels - 1)).round().clamp(0, levels - 1);
    return _colors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    // Align start to Monday
    final gridStart = startDate.subtract(
      Duration(days: (startDate.weekday - 1) % 7),
    );
    // Calculate weeks
    final totalDays = endDate.difference(gridStart).inDays + 1;
    final totalWeeks = (totalDays / 7).ceil();
    final dayCount = endDate.difference(startDate).inDays + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title bar
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(
                  title!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: CalendarColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l.nDays(dayCount),
                    style: TextStyle(
                      fontSize: 12,
                      color: CalendarColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Statistics summary
        _buildStats(context, theme),
        const SizedBox(height: 12),
        // Month labels
        if (showMonthLabels) _buildMonthLabels(context, theme, gridStart, totalWeeks),
        const SizedBox(height: 4),
        // Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showWeekdayLabels) ...[
              _buildWeekdayLabels(context, theme),
              const SizedBox(width: 4),
            ],
            Expanded(child: _buildGrid(gridStart, totalWeeks)),
          ],
        ),
        const SizedBox(height: 8),
        // Legend
        _buildLegend(context, theme),
      ],
    );
  }

  Widget _buildStats(BuildContext context, ThemeData theme) {
    int totalValue = 0;
    int activeDays = 0;
    int maxStreak = 0;
    int currentStreak = 0;

    for (final entry in data.entries) {
      totalValue += entry.value;
      if (entry.value > 0) {
        activeDays++;
      }
    }

    // Calculate streak
    var d = endDate;
    while (!d.isBefore(startDate)) {
      final v = _getValue(d);
      if (v > 0) {
        currentStreak++;
        if (currentStreak > maxStreak) maxStreak = currentStreak;
      } else {
        currentStreak = 0;
      }
      d = d.subtract(const Duration(days: 1));
    }

    final l = AppLocalizations.of(context);
    return Row(
      children: [
        _StatChip(label: l.total, value: '$totalValue', color: _colors.last),
        const SizedBox(width: 12),
        _StatChip(label: l.activeDays, value: '$activeDays', color: _colors[_colors.length ~/ 2]),
        const SizedBox(width: 12),
        _StatChip(label: l.longestStreak, value: l.nDays(maxStreak), color: CalendarColors.primary),
      ],
    );
  }

  Widget _buildMonthLabels(BuildContext context, ThemeData theme, DateTime gridStart, int totalWeeks) {
    final labels = <Widget>[];
    if (showWeekdayLabels) {
      labels.add(const SizedBox(width: 28));
    }

    int lastMonth = 0;
    final cellTotal = cellSize + cellSpacing;

    for (int w = 0; w < totalWeeks; w++) {
      final weekStart = gridStart.add(Duration(days: w * 7));
      final inRange = !weekStart.isBefore(startDate) && !weekStart.isAfter(endDate);
      if (inRange && weekStart.month != lastMonth) {
        lastMonth = weekStart.month;
        labels.add(
          SizedBox(
            width: cellTotal,
            child: Text(
              AppLocalizations.of(context).monthNamesShort[weekStart.month],
              style: TextStyle(fontSize: 9, color: Colors.grey[600]),
              overflow: TextOverflow.visible,
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

  Widget _buildWeekdayLabels(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    return Column(
      children: List.generate(7, (i) {
        final wd = i + 1;
        return SizedBox(
          height: cellSize + cellSpacing,
          width: 24,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              l.weekdayShort(wd),
              style: TextStyle(fontSize: 9, color: Colors.grey[600]),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGrid(DateTime gridStart, int totalWeeks) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(totalWeeks, (w) {
          return Column(
            children: List.generate(7, (d) {
              final date = gridStart.add(Duration(days: w * 7 + d));
              final inRange =
                  !date.isBefore(startDate) && !date.isAfter(endDate);
              final value = inRange ? _getValue(date) : 0;
              final color = inRange ? _colorForValue(value) : Colors.transparent;

              return GestureDetector(
                onTap: inRange ? () => onDayTap?.call(date) : null,
                child: Tooltip(
                  message: inRange
                      ? '${date.year}/${date.month}/${date.day}: $value'
                      : '',
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    margin: EdgeInsets.all(cellSpacing / 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
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

  Widget _buildLegend(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(l.less, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        const SizedBox(width: 4),
        ..._colors.map((color) {
          return Container(
            width: cellSize,
            height: cellSize,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text(l.more_, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
