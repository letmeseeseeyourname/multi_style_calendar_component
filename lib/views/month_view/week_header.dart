import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/calendar_theme.dart';

/// A row of weekday labels (Monday through Sunday) displayed above the month grid.
class WeekHeader extends StatelessWidget {
  /// The first day of the week (1 = Monday, 7 = Sunday).
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

  /// Generates an ordered list of weekday numbers (1-7) based on [firstDayOfWeek].
  List<int> _buildWeekdays() {
    final weekdays = <int>[];
    for (int i = 0; i < 7; i++) {
      final weekday = ((firstDayOfWeek - 1 + i) % 7) + 1;
      weekdays.add(weekday);
    }
    return weekdays;
  }
}
