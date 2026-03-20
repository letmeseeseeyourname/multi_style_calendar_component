import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import 'year_month_cell.dart';

/// 年视图 - 以 3x4 或 4x3 网格展示 12 个月份缩略图
class YearView extends StatelessWidget {
  /// 显示的年份
  final int year;

  /// 事件列表（用于在月份缩略图上显示事件指示）
  final List<CalendarEvent> events;

  /// 点击某个月份时的回调
  final ValueChanged<DateTime>? onMonthTap;

  /// 点击某个日期时的回调
  final ValueChanged<DateTime>? onDateTap;

  /// 周起始日（1=周一，7=周日）
  final int firstDayOfWeek;

  /// 是否使用横屏布局（4x3）
  final bool landscape;

  const YearView({
    super.key,
    required this.year,
    this.events = const [],
    this.onMonthTap,
    this.onDateTap,
    this.firstDayOfWeek = 1,
    this.landscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = landscape ? 4 : 3;

    return Column(
      children: [
        _buildYearHeader(context),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: landscape ? 1.2 : 0.95,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final monthDate = DateTime(year, month, 1);
              final monthEvents = events
                  .where((e) => _eventInMonth(e, year, month))
                  .toList();

              return YearMonthCell(
                month: monthDate,
                events: monthEvents,
                firstDayOfWeek: firstDayOfWeek,
                onMonthTap: onMonthTap,
                onDateTap: onDateTap,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildYearHeader(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        '$year${l.yearSuffix}',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  bool _eventInMonth(CalendarEvent event, int year, int month) {
    final monthStart = DateTime(year, month, 1);
    final daysCount = CalendarDateUtils.daysInMonth(year, month);
    final monthEnd = DateTime(year, month, daysCount, 23, 59, 59);
    return !event.endTime.isBefore(monthStart) &&
        !event.startTime.isAfter(monthEnd);
  }
}
