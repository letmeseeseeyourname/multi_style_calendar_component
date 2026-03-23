import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/calendar_theme.dart';

/// 周标题行，显示周一至周日的名称
class WeekHeader extends StatelessWidget {
  /// 一周的起始日（1=周一, 7=周日）
  final int firstDayOfWeek;

  const WeekHeader({super.key, this.firstDayOfWeek = 1});

  @override
  Widget build(BuildContext context) {
    final theme = CalendarTheme.of(context);
    final l = AppLocalizations.of(context);
    final weekdays = _buildWeekdays();

    return SizedBox(
      height: 32,
      child: Row(
        children: weekdays.map((weekday) {
          final isWeekend = weekday == 6 || weekday == 7;
          return Expanded(
            child: Center(
              child: Text(
                l.weekdayShort(weekday),
                style: theme.weekdayTextStyle.copyWith(
                  color: isWeekend ? theme.weekendColor : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 根据 firstDayOfWeek 生成有序的周日编号列表 (1-7)
  List<int> _buildWeekdays() {
    final weekdays = <int>[];
    for (int i = 0; i < 7; i++) {
      final weekday = ((firstDayOfWeek - 1 + i) % 7) + 1;
      weekdays.add(weekday);
    }
    return weekdays;
  }
}
