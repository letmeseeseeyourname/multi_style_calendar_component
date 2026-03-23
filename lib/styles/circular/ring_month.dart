import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// Ring/donut month view: days arranged in concentric rings.
/// The month is split across rings of ~10 days each, with the
/// innermost ring holding the first days.
class RingMonthView extends StatefulWidget {
  final DateTime? initialMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final double size;

  const RingMonthView({
    super.key,
    this.initialMonth,
    this.selectedDate,
    this.onDateSelected,
    this.size = 340,
  });

  @override
  State<RingMonthView> createState() => _RingMonthViewState();
}

class _RingMonthViewState extends State<RingMonthView>
    with SingleTickerProviderStateMixin {
  late DateTime _currentMonth;
  DateTime? _selectedDate;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = widget.initialMonth ?? DateTime(now.year, now.month, 1);
    _selectedDate = widget.selectedDate;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
    _animController.forward(from: 0);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInMonth = CalendarDateUtils.daysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    final monthName = CalendarDateUtils.monthName(_currentMonth.month);

    // Split days into rings of ~10
    final rings = <List<int>>[];
    const daysPerRing = 10;
    for (int i = 1; i <= daysInMonth; i += daysPerRing) {
      final end = (i + daysPerRing - 1).clamp(1, daysInMonth);
      rings.add(List.generate(end - i + 1, (j) => i + j));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
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
              ),
            ],
          ),
        ),
        // Ring layout
        AnimatedBuilder(
          listenable: _animController,
          builder: (context, _) {
            final progress = CurvedAnimation(
              parent: _animController,
              curve: Curves.easeOutCubic,
            ).value;

            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center month label
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        monthName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: CalendarColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_currentMonth.year}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Draw ring backgrounds
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _RingPainter(
                      ringCount: rings.length,
                      baseRadius: 50,
                      ringSpacing: 38,
                      progress: progress,
                    ),
                  ),
                  // Day nodes on rings
                  ...List.generate(rings.length, (ringIdx) {
                    final ringDays = rings[ringIdx];
                    final radius = (50.0 + ringIdx * 38) * progress;
                    return Stack(
                      alignment: Alignment.center,
                      children: List.generate(ringDays.length, (dayIdx) {
                        final day = ringDays[dayIdx];
                        final angle =
                            (2 * math.pi / ringDays.length) * dayIdx -
                            math.pi / 2;
                        final dx = radius * math.cos(angle);
                        final dy = radius * math.sin(angle);

                        return Transform.translate(
                          offset: Offset(dx, dy),
                          child: _buildDayDot(day, theme),
                        );
                      }),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDayDot(int day, ThemeData theme) {
    final date = DateTime(_currentMonth.year, _currentMonth.month, day);
    final isToday = CalendarDateUtils.isSameDay(date, DateTime.now());
    final isSelected =
        _selectedDate != null &&
        CalendarDateUtils.isSameDay(date, _selectedDate!);
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedDate = date);
        widget.onDateSelected?.call(date);
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? CalendarColors.selected
              : isToday
              ? CalendarColors.today
              : Colors.white,
          border: Border.all(
            color: isToday
                ? CalendarColors.today
                : isWeekend
                ? CalendarColors.weekend.withValues(alpha: 0.5)
                : Colors.grey[300]!,
            width: isToday ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 11,
            fontWeight: (isToday || isSelected)
                ? FontWeight.bold
                : FontWeight.w500,
            color: (isSelected || isToday)
                ? Colors.white
                : isWeekend
                ? CalendarColors.weekend
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final int ringCount;
  final double baseRadius;
  final double ringSpacing;
  final double progress;

  _RingPainter({
    required this.ringCount,
    required this.baseRadius,
    required this.ringSpacing,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < ringCount; i++) {
      final radius = (baseRadius + i * ringSpacing) * progress;
      paint.color = Colors.grey.withValues(alpha: 0.2);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Helper animated builder.
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
  }) : super();

  @override
  Widget build(BuildContext context) => builder(context, null);
}
