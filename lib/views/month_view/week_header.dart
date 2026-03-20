import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/calendar_theme.dart';

/// 周标题行，显示周一至周日的名称
class WeekHeader extends StatelessWidget {
  /// 一周的起始日（1=周一, 7=周日）
  final int firstDayOfWeek;

  const WeekHeader({
    super.key,
    this.firstDayOfWeek = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CalendarTheme.of(context);
    final weekdays = _buildWeekdayNames();

    return SizedBox(
      height: 32,
      child: Row(
        children: weekdays.map((name) {
          final isWeekend = _isWeekendName(name);
          return Expanded(
            child: Center(
              child: Text(
                name,
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

  /// 根据 firstDayOfWeek 生成有序的周名称列表
  List<String> _buildWeekdayNames() {
    final names = <String>[];
    for (int i = 0; i < 7; i++) {
      final weekday = ((firstDayOfWeek - 1 + i) % 7) + 1;
      names.add(CalendarDateUtils.weekdayName(weekday));
    }
    return names;
  }

  bool _isWeekendName(String name) {
    return name == '六' || name == '日';
  }
}
