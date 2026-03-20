import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// Traditional grid calendar with clean lines and standard layout.
/// Displays a full month view in a classic 7-column grid.
class ClassicGridCalendar extends StatefulWidget {
  final DateTime? initialMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Map<DateTime, List<String>>? events;

  const ClassicGridCalendar({
    super.key,
    this.initialMonth,
    this.selectedDate,
    this.onDateSelected,
    this.events,
  });

  @override
  State<ClassicGridCalendar> createState() => _ClassicGridCalendarState();
}

class _ClassicGridCalendarState extends State<ClassicGridCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = widget.initialMonth ?? DateTime(now.year, now.month, 1);
    _selectedDate = widget.selectedDate;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
        1,
      );
    });
  }

  int _eventCount(DateTime date) {
    if (widget.events == null) return 0;
    final key = CalendarDateUtils.dateOnly(date);
    for (final entry in widget.events!.entries) {
      if (CalendarDateUtils.isSameDay(entry.key, key)) {
        return entry.value.length;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final days = CalendarDateUtils.daysInMonthGrid(_currentMonth);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with navigation
        _buildHeader(theme),
        const Divider(height: 1),
        // Weekday labels
        _buildWeekdayRow(theme),
        const Divider(height: 1),
        // Date grid
        _buildGrid(days, theme),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final monthName = CalendarDateUtils.monthName(_currentMonth.month);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
            splashRadius: 20,
          ),
          Text(
            '${_currentMonth.year}年 $monthName',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayRow(ThemeData theme) {
    const weekdays = [1, 2, 3, 4, 5, 6, 7];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: weekdays.map((wd) {
          final isWeekend = wd == 6 || wd == 7;
          return Expanded(
            child: Center(
              child: Text(
                CalendarDateUtils.weekdayName(wd),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isWeekend ? CalendarColors.weekend : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGrid(List<DateTime> days, ThemeData theme) {
    final rows = <Widget>[];
    for (int week = 0; week < 6; week++) {
      final weekDays = days.sublist(week * 7, week * 7 + 7);
      rows.add(_buildWeekRow(weekDays, theme));
      if (week < 5) {
        rows.add(Divider(height: 1, color: Colors.grey[200]));
      }
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildWeekRow(List<DateTime> weekDays, ThemeData theme) {
    return Row(
      children: weekDays.map((date) {
        final isCurrentMonth = CalendarDateUtils.isSameMonth(date, _currentMonth);
        final isToday = CalendarDateUtils.isSameDay(date, DateTime.now());
        final isSelected =
            _selectedDate != null && CalendarDateUtils.isSameDay(date, _selectedDate!);
        final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
        final eventCount = _eventCount(date);

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedDate = date);
              widget.onDateSelected?.call(date);
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? CalendarColors.selected.withValues(alpha: 0.12)
                    : null,
                border: Border(
                  left: BorderSide(
                    color: Colors.grey[200]!,
                    width: date.weekday == 1 ? 0 : 0.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday ? CalendarColors.today : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isToday
                            ? Colors.white
                            : !isCurrentMonth
                                ? CalendarColors.disabled
                                : isWeekend
                                    ? CalendarColors.weekend
                                    : null,
                        fontWeight: isToday ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  if (eventCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          eventCount.clamp(0, 3),
                          (i) => Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CalendarColors.eventColors[
                                  i % CalendarColors.eventColors.length],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
