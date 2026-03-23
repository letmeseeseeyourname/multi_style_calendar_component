import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// 年视图中的月份缩略单元格
/// 显示紧凑的月份名称和 7 列小型日期网格
class YearMonthCell extends StatelessWidget {
  /// 该月的第一天
  final DateTime month;

  /// 该月的事件列表
  final List<CalendarEvent> events;

  /// 周起始日
  final int firstDayOfWeek;

  /// 点击月份标题时的回调
  final ValueChanged<DateTime>? onMonthTap;

  /// 点击具体日期时的回调
  final ValueChanged<DateTime>? onDateTap;

  const YearMonthCell({
    super.key,
    required this.month,
    this.events = const [],
    this.firstDayOfWeek = 1,
    this.onMonthTap,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = CalendarDateUtils.daysInMonthGrid(
      month,
      firstDayOfWeek: firstDayOfWeek,
    );
    final today = CalendarDateUtils.dateOnly(DateTime.now());

    return GestureDetector(
      onTap: () => onMonthTap?.call(month),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 月份标题
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                CalendarDateUtils.monthName(month.month),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _isCurrentMonth()
                      ? CalendarColors.primary
                      : theme.textTheme.labelLarge?.color,
                ),
              ),
            ),
            // 星期标题行
            _buildWeekdayHeader(theme),
            const SizedBox(height: 2),
            // 日期网格
            Expanded(child: _buildDayGrid(theme, days, today)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader(ThemeData theme) {
    return Row(
      children: List.generate(7, (i) {
        final weekday = (firstDayOfWeek + i - 1) % 7 + 1;
        final isWeekend =
            weekday == DateTime.saturday || weekday == DateTime.sunday;
        return Expanded(
          child: Center(
            child: Text(
              CalendarDateUtils.weekdayName(weekday),
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 8,
                color: isWeekend
                    ? CalendarColors.weekend.withValues(alpha: 0.7)
                    : theme.hintColor,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDayGrid(ThemeData theme, List<DateTime> days, DateTime today) {
    // 42 cells in a 6x7 grid
    final rowCount = 6;
    return Column(
      children: List.generate(rowCount, (row) {
        return Expanded(
          child: Row(
            children: List.generate(7, (col) {
              final index = row * 7 + col;
              if (index >= days.length)
                return const Expanded(child: SizedBox());
              final day = days[index];
              final isCurrentMonth =
                  day.month == month.month && day.year == month.year;
              final isToday = day == today;
              final hasEvent = events.any((e) => e.occursOn(day));

              return Expanded(
                child: GestureDetector(
                  onTap: isCurrentMonth ? () => onDateTap?.call(day) : null,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: isToday
                        ? BoxDecoration(
                            color: CalendarColors.today,
                            shape: BoxShape.circle,
                          )
                        : null,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 9,
                            color: isToday
                                ? Colors.white
                                : isCurrentMonth
                                ? theme.textTheme.bodySmall?.color
                                : Colors.transparent,
                          ),
                        ),
                        if (hasEvent && isCurrentMonth && !isToday)
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: const BoxDecoration(
                                color: CalendarColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  bool _isCurrentMonth() {
    final now = DateTime.now();
    return month.year == now.year && month.month == now.month;
  }
}
