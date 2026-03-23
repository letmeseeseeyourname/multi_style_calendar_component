import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// Card-based calendar where each day is a Material Card
/// with elevation and rounded corners.
class CardCalendar extends StatefulWidget {
  final DateTime? initialMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Map<DateTime, List<String>>? events;

  const CardCalendar({
    super.key,
    this.initialMonth,
    this.selectedDate,
    this.onDateSelected,
    this.events,
  });

  @override
  State<CardCalendar> createState() => _CardCalendarState();
}

class _CardCalendarState extends State<CardCalendar> {
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
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  int _eventCount(DateTime date) {
    if (widget.events == null) return 0;
    for (final entry in widget.events!.entries) {
      if (CalendarDateUtils.isSameDay(entry.key, date)) {
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
        _buildHeader(theme),
        const SizedBox(height: 8),
        _buildWeekdayRow(theme),
        const SizedBox(height: 4),
        _buildGrid(days, theme),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final monthName = CalendarDateUtils.monthName(_currentMonth.month);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: _previousMonth,
          ),
          Text(
            '${_currentMonth.year}年 $monthName',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayRow(ThemeData theme) {
    return Row(
      children: List.generate(7, (i) {
        final wd = i + 1;
        return Expanded(
          child: Center(
            child: Text(
              CalendarDateUtils.weekdayName(wd),
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGrid(List<DateTime> days, ThemeData theme) {
    final rows = <Widget>[];
    for (int week = 0; week < 6; week++) {
      final weekDays = days.sublist(week * 7, week * 7 + 7);
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: weekDays
                .map((date) => _buildDayCard(date, theme))
                .toList(),
          ),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildDayCard(DateTime date, ThemeData theme) {
    final isCurrentMonth = CalendarDateUtils.isSameMonth(date, _currentMonth);
    final isToday = CalendarDateUtils.isSameDay(date, DateTime.now());
    final isSelected =
        _selectedDate != null &&
        CalendarDateUtils.isSameDay(date, _selectedDate!);
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final eventCount = _eventCount(date);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: GestureDetector(
          onTap: () {
            setState(() => _selectedDate = date);
            widget.onDateSelected?.call(date);
          },
          child: Card(
            elevation: isSelected ? 4 : (isToday ? 2 : 0.5),
            shadowColor: isSelected
                ? CalendarColors.selected.withValues(alpha: 0.4)
                : Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isToday
                  ? const BorderSide(color: CalendarColors.today, width: 1.5)
                  : BorderSide.none,
            ),
            color: isSelected
                ? CalendarColors.selected
                : isCurrentMonth
                ? theme.cardColor
                : Colors.grey[50],
            child: SizedBox(
              height: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : !isCurrentMonth
                          ? CalendarColors.disabled
                          : isWeekend
                          ? CalendarColors.weekend
                          : null,
                      fontWeight: (isToday || isSelected)
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                  if (eventCount > 0) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.3)
                            : CalendarColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$eventCount',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : CalendarColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
