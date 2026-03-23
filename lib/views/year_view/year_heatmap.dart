import 'package:flutter/material.dart';

import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/color_schemes.dart';

/// GitHub 风格的年度热力图
/// 水平滚动，7 行（周一到周日）x ~53 列（周）
class YearHeatmap extends StatelessWidget {
  /// 显示的年份
  final int year;

  /// 日期 -> 活动强度值的映射
  final Map<DateTime, int> data;

  /// 热力图基础颜色
  final Color baseColor;

  /// 最大值（用于计算颜色强度）
  final int maxValue;

  /// 单元格大小
  final double cellSize;

  /// 单元格间距
  final double cellSpacing;

  /// 点击日期回调
  final ValueChanged<DateTime>? onDateTap;

  const YearHeatmap({
    super.key,
    required this.year,
    required this.data,
    this.baseColor = const Color(0xFF4CAF50),
    this.maxValue = 10,
    this.cellSize = 14,
    this.cellSpacing = 2,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context, theme),
        const SizedBox(height: 8),
        _buildMonthLabels(context, theme),
        const SizedBox(height: 4),
        SizedBox(
          height: (cellSize + cellSpacing) * 7,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeekdayLabels(context, theme),
              const SizedBox(width: 4),
              Expanded(child: _buildHeatmapGrid(context, theme)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildLegend(context, theme),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    final totalActivities = data.values.fold<int>(0, (sum, v) => sum + v);
    return Row(
      children: [
        Text(
          l.yearActivityTitle(year),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          l.totalActivities(totalActivities),
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
      ],
    );
  }

  Widget _buildMonthLabels(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    // 计算每个月大致对应的周列位置
    final firstDay = DateTime(year, 1, 1);
    final firstDayWeekday = firstDay.weekday; // 1=Mon
    final offsetToMonday = (firstDayWeekday - 1) % 7;

    return Padding(
      padding: EdgeInsets.only(left: 28), // align with grid
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: List.generate(12, (i) {
            final monthStart = DateTime(year, i + 1, 1);
            final dayOfYear = monthStart.difference(firstDay).inDays;
            final weekIndex = (dayOfYear + offsetToMonday) ~/ 7;
            // weekIndex used for positioning
            final _ = weekIndex * (cellSize + cellSpacing);

            // Calculate width to next month or end
            final nextMonthWeek = i < 11
                ? (DateTime(year, i + 2, 1).difference(firstDay).inDays +
                          offsetToMonday) ~/
                      7
                : 53;
            final width =
                (nextMonthWeek - weekIndex) * (cellSize + cellSpacing);

            return SizedBox(
              width: width,
              child: Text(
                l.monthNamesShort[i + 1],
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: theme.hintColor,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWeekdayLabels(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    // Show labels for Mon(1), Wed(3), Fri(5), Sun(7); blank for others
    final displayDays = {1, 3, 5, 7};
    return Column(
      children: List.generate(7, (i) {
        final weekday = i + 1; // 1=Mon .. 7=Sun
        return SizedBox(
          height: cellSize + cellSpacing,
          width: 22,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              displayDays.contains(weekday) ? l.weekdayShort(weekday) : '',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9,
                color: theme.hintColor,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeatmapGrid(BuildContext context, ThemeData theme) {
    final firstDay = DateTime(year, 1, 1);
    final lastDay = DateTime(year, 12, 31);
    final totalDays = lastDay.difference(firstDay).inDays + 1;

    // Build week columns
    // First, organize days into a grid: row = weekday (0=Mon), col = week
    // firstDay.weekday is 1=Monday
    final weeks = <List<DateTime?>>[];

    // First partial week
    List<DateTime?> currentWeek = List.filled(7, null);
    for (int i = 0; i < totalDays; i++) {
      final day = firstDay.add(Duration(days: i));
      final weekdayIndex = (day.weekday - 1) % 7; // 0=Mon

      if (i > 0 && weekdayIndex == 0) {
        weeks.add(currentWeek);
        currentWeek = List.filled(7, null);
      }
      currentWeek[weekdayIndex] = day;
    }
    weeks.add(currentWeek);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: weeks.map((week) {
          return Column(
            children: List.generate(7, (dayIndex) {
              final day = week[dayIndex];
              if (day == null) {
                return SizedBox(
                  width: cellSize + cellSpacing,
                  height: cellSize + cellSpacing,
                );
              }

              final dateKey = CalendarDateUtils.dateOnly(day);
              final value = data[dateKey] ?? 0;
              final clampedMax = maxValue > 0 ? maxValue : 1;
              final intensity = (value / clampedMax).clamp(0.0, 1.0);

              final color = value == 0
                  ? theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    )
                  : CalendarColors.heatmapColor(intensity, baseColor);

              final isToday = CalendarDateUtils.isSameDay(day, DateTime.now());

              return Padding(
                padding: EdgeInsets.all(cellSpacing / 2),
                child: GestureDetector(
                  onTap: () => onDateTap?.call(day),
                  child: Tooltip(
                    message: AppLocalizations.of(
                      context,
                    ).dayActivityTooltip(day.month, day.day, value),
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                        border: isToday
                            ? Border.all(
                                color: CalendarColors.today,
                                width: 1.5,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          l.less,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: theme.hintColor,
          ),
        ),
        const SizedBox(width: 4),
        ...List.generate(5, (i) {
          final intensity = i / 4;
          final color = i == 0
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : CalendarColors.heatmapColor(intensity, baseColor);
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
        Text(
          l.more_,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: theme.hintColor,
          ),
        ),
      ],
    );
  }
}
