import 'package:flutter/material.dart';
import '../../core/models/calendar_date.dart';
import '../../core/models/calendar_event.dart';
import '../../core/models/calendar_config.dart';
import '../../core/utils/date_utils.dart';
import 'day_cell.dart';

/// 月网格，7 列 6 行共 42 个日期单元格
class MonthGrid extends StatelessWidget {
  final DateTime month;
  final CalendarConfig config;
  final List<CalendarEvent> events;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateTap;

  const MonthGrid({
    super.key,
    required this.month,
    this.config = const CalendarConfig(),
    this.events = const [],
    this.selectedDate,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final days = CalendarDateUtils.daysInMonthGrid(
      month,
      firstDayOfWeek: config.firstDayOfWeek,
    );

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.85,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final date = days[index];
        final calendarDate = CalendarDate.fromDateTime(date);
        final isCurrentMonth = CalendarDateUtils.isSameMonth(date, month);
        final isSelected = selectedDate != null &&
            CalendarDateUtils.isSameDay(date, selectedDate!);

        // 获取当天事件
        final dayEvents = events.where((e) => e.occursOn(date)).toList();

        return DayCell(
          date: calendarDate,
          events: dayEvents,
          isSelected: isSelected,
          isCurrentMonth: isCurrentMonth,
          showLunar: config.showLunar,
          onTap: () => onDateTap?.call(date),
        );
      },
    );
  }
}
