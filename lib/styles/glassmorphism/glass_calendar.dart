import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// Frosted glass effect calendar using BackdropFilter and
/// semi-transparent containers. Designed to be placed over
/// a colorful or image background.
class GlassCalendar extends StatefulWidget {
  final DateTime? initialMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  /// Background widget displayed behind the glass.
  /// If null, a default gradient is used.
  final Widget? background;

  const GlassCalendar({
    super.key,
    this.initialMonth,
    this.selectedDate,
    this.onDateSelected,
    this.background,
  });

  @override
  State<GlassCalendar> createState() => _GlassCalendarState();
}

class _GlassCalendarState extends State<GlassCalendar> {
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

    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: widget.background ?? _defaultBackground(),
        ),
        // Glass calendar overlay
        Padding(
          padding: const EdgeInsets.all(16),
          child: _GlassContainer(
            borderRadius: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildWeekdayRow(),
                const SizedBox(height: 8),
                _buildGrid(days),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _defaultBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFFf093fb),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final monthName = CalendarDateUtils.monthName(_currentMonth.month);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _GlassIconButton(
            icon: Icons.chevron_left,
            onTap: _previousMonth,
          ),
          Column(
            children: [
              Text(
                monthName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_currentMonth.year}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          _GlassIconButton(
            icon: Icons.chevron_right,
            onTap: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(7, (i) {
          final wd = i + 1;
          return Expanded(
            child: Center(
              child: Text(
                CalendarDateUtils.weekdayName(wd),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildGrid(List<DateTime> days) {
    final rows = <Widget>[];
    for (int week = 0; week < 6; week++) {
      final weekDays = days.sublist(week * 7, week * 7 + 7);
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
        _selectedDate != null && CalendarDateUtils.isSameDay(date, _selectedDate!);
    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    Color textColor;
    if (!isCurrentMonth) {
      textColor = Colors.white.withValues(alpha: 0.2);
    } else if (isSelected || isToday) {
      textColor = Colors.white;
    } else if (isWeekend) {
      textColor = Colors.white.withValues(alpha: 0.6);
    } else {
      textColor = Colors.white.withValues(alpha: 0.9);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedDate = date);
          widget.onDateSelected?.call(date);
        },
        child: Center(
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.35)
                  : isToday
                      ? Colors.white.withValues(alpha: 0.2)
                      : null,
              border: isToday && !isSelected
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1.5,
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.15),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    (isToday || isSelected) ? FontWeight.w600 : FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A frosted glass container widget.
class _GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color tint;

  const _GlassContainer({
    required this.child,
    this.borderRadius = 16,
    this.blur = 12,
    this.tint = const Color(0x30FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A small glass-style icon button.
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    );
  }
}
