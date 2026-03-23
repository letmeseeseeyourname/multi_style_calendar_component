import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import 'streak_counter.dart';
import 'habit_stats.dart';

/// A habit tracking calendar that lets users mark daily completions.
///
/// Displays streak statistics and a month grid where each day can be
/// tapped to toggle its completion status. Future dates are disabled.
class HabitCalendar extends StatefulWidget {
  const HabitCalendar({super.key});

  @override
  State<HabitCalendar> createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  late DateTime _currentMonth;
  late Set<DateTime> _completedDates;
  late StreakCounter _streakCounter;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _streakCounter = StreakCounter.createMockData();
    _completedDates = Set.from(_streakCounter.completedDates);
  }

  void _rebuildCounter() {
    _streakCounter = StreakCounter(completedDates: _completedDates);
  }

  void _toggleDate(DateTime date) {
    setState(() {
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (_completedDates.any(
        (d) =>
            d.year == dateOnly.year &&
            d.month == dateOnly.month &&
            d.day == dateOnly.day,
      )) {
        _completedDates.removeWhere(
          (d) =>
              d.year == dateOnly.year &&
              d.month == dateOnly.month &&
              d.day == dateOnly.day,
        );
      } else {
        _completedDates.add(dateOnly);
      }
      _rebuildCounter();
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Stats
          HabitStats(streakCounter: _streakCounter, month: _currentMonth),
          const SizedBox(height: 16),
          // Month header
          _buildMonthHeader(),
          const SizedBox(height: 8),
          // Weekday header
          _buildWeekdayHeader(),
          const SizedBox(height: 4),
          // Calendar grid
          _buildCalendarGrid(gridDays),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _changeMonth(-1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          AppLocalizations.of(
            context,
          ).yearMonth(_currentMonth.year, _currentMonth.month),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => _changeMonth(1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    return Row(
      children: List.generate(7, (index) {
        final weekday = (index + 1) % 7 == 0 ? 7 : (index + 1);
        return Expanded(
          child: Center(
            child: Text(
              CalendarDateUtils.weekdayName(weekday),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> gridDays) {
    final now = DateTime.now();
    final rows = <Widget>[];

    for (int i = 0; i < gridDays.length; i += 7) {
      rows.add(
        Row(
          children: List.generate(7, (j) {
            final date = gridDays[i + j];
            final isCurrentMonth = date.month == _currentMonth.month;
            final isToday = CalendarDateUtils.isSameDay(date, now);
            final isFuture = date.isAfter(now);
            final isCompleted = _streakCounter.isCompleted(date);

            return Expanded(
              child: GestureDetector(
                onTap: (isCurrentMonth && !isFuture)
                    ? () => _toggleDate(date)
                    : null,
                child: _HabitDayCell(
                  date: date,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  isFuture: isFuture,
                  isCompleted: isCompleted,
                ),
              ),
            );
          }),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _HabitDayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isFuture;
  final bool isCompleted;

  const _HabitDayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isFuture,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFF4CAF50).withValues(alpha: 0.15)
            : null,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: const Color(0xFF4CAF50), width: 2)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: !isCurrentMonth
                      ? Colors.grey.shade300
                      : isFuture
                      ? Colors.grey.shade400
                      : isCompleted
                      ? const Color(0xFF2E7D32)
                      : Colors.black87,
                ),
              ),
            ],
          ),
          if (isCompleted && isCurrentMonth)
            Positioned(
              bottom: 4,
              child: Icon(
                Icons.check_circle,
                size: 14,
                color: const Color(0xFF4CAF50).withValues(alpha: 0.8),
              ),
            ),
        ],
      ),
    );
  }
}
