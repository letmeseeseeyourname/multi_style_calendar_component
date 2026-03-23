import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// Ultra-minimal calendar with just numbers, lots of whitespace, and thin fonts.
/// Inspired by minimalist design with maximum breathing room.
class MinimalCalendar extends StatefulWidget {
  final DateTime? initialMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  const MinimalCalendar({
    super.key,
    this.initialMonth,
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  State<MinimalCalendar> createState() => _MinimalCalendarState();
}

class _MinimalCalendarState extends State<MinimalCalendar> {
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

  @override
  Widget build(BuildContext context) {
    final days = CalendarDateUtils.daysInMonthGrid(_currentMonth);
    final monthName = CalendarDateUtils.monthName(_currentMonth.month);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          // Header: year and month on separate lines
          _buildHeader(monthName),
          const SizedBox(height: 32),
          // Weekday labels
          _buildWeekdayRow(),
          const SizedBox(height: 16),
          // Date grid
          _buildGrid(days),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(String monthName) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0) {
          _nextMonth();
        } else {
          _previousMonth();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_currentMonth.year}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[400],
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                monthName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey[800],
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              GestureDetector(
                onTap: _previousMonth,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _nextMonth,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayRow() {
    return Row(
      children: List.generate(7, (i) {
        final wd = i + 1;
        return Expanded(
          child: Center(
            child: Text(
              CalendarDateUtils.weekdayName(wd),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: Colors.grey[400],
                letterSpacing: 1,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGrid(List<DateTime> days) {
    final rows = <Widget>[];
    for (int week = 0; week < 6; week++) {
      final weekDays = days.sublist(week * 7, week * 7 + 7);
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: weekDays.map((date) => _buildDay(date)).toList(),
          ),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildDay(DateTime date) {
    final isCurrentMonth = CalendarDateUtils.isSameMonth(date, _currentMonth);
    final isToday = CalendarDateUtils.isSameDay(date, DateTime.now());
    final isSelected =
        _selectedDate != null &&
        CalendarDateUtils.isSameDay(date, _selectedDate!);

    Color textColor;
    if (!isCurrentMonth) {
      textColor = Colors.grey[300]!;
    } else if (isSelected) {
      textColor = Colors.white;
    } else if (isToday) {
      textColor = CalendarColors.primary;
    } else {
      textColor = Colors.grey[700]!;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedDate = date);
          widget.onDateSelected?.call(date);
        },
        child: Center(
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: isSelected
                ? BoxDecoration(shape: BoxShape.circle, color: Colors.grey[800])
                : isToday
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CalendarColors.primary.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  )
                : null,
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
