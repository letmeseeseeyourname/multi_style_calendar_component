import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/color_schemes.dart';

/// Circular week view: 7 days arranged in a circle.
/// The current day is highlighted, and tapping a day selects it.
class CircularWeekView extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Map<DateTime, int>? eventCounts;
  final double size;

  const CircularWeekView({
    super.key,
    this.initialDate,
    this.selectedDate,
    this.onDateSelected,
    this.eventCounts,
    this.size = 320,
  });

  @override
  State<CircularWeekView> createState() => _CircularWeekViewState();
}

class _CircularWeekViewState extends State<CircularWeekView>
    with SingleTickerProviderStateMixin {
  late DateTime _weekStart;
  DateTime? _selectedDate;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    final base = widget.initialDate ?? DateTime.now();
    _weekStart = CalendarDateUtils.firstDayOfWeek(base);
    _selectedDate = widget.selectedDate;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _previousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
    });
    _animController.forward(from: 0);
  }

  void _nextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
    _animController.forward(from: 0);
  }

  int _eventCount(DateTime date) {
    if (widget.eventCounts == null) return 0;
    for (final entry in widget.eventCounts!.entries) {
      if (CalendarDateUtils.isSameDay(entry.key, date)) {
        return entry.value;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));
    final weekNum = CalendarDateUtils.weekNumber(_weekStart);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Navigation
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousWeek,
              ),
              Text(
                l.weekNumber(weekNum),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextWeek,
              ),
            ],
          ),
        ),
        // Circular layout
        AnimatedBuilder(
          listenable: _scaleAnim,
          builder: (context, child) {
            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center info
                  _buildCenterInfo(context, theme),
                  // Connecting lines painted behind day nodes
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _CircleLinePainter(
                      dayCount: 7,
                      radius: widget.size / 2 - 36,
                      color: Colors.grey[300]!,
                    ),
                  ),
                  // Day nodes
                  ...List.generate(7, (i) {
                    final angle = (2 * math.pi / 7) * i - math.pi / 2;
                    final radius = (widget.size / 2 - 36) * _scaleAnim.value;
                    final dx = radius * math.cos(angle);
                    final dy = radius * math.sin(angle);

                    return Transform.translate(
                      offset: Offset(dx, dy),
                      child: _buildDayNode(context, days[i], theme),
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

  Widget _buildCenterInfo(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    final display = _selectedDate ?? DateTime.now();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.monthNamesShort[display.month],
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        Text(
          '${display.year}',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CalendarColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDayNode(BuildContext context, DateTime date, ThemeData theme) {
    final isToday = CalendarDateUtils.isSameDay(date, DateTime.now());
    final isSelected =
        _selectedDate != null &&
        CalendarDateUtils.isSameDay(date, _selectedDate!);
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final events = _eventCount(date);

    return GestureDetector(
      onTap: () {
        setState(() => _selectedDate = date);
        widget.onDateSelected?.call(date);
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? CalendarColors.selected
              : isToday
              ? CalendarColors.today.withValues(alpha: 0.15)
              : theme.cardColor,
          border: Border.all(
            color: isToday ? CalendarColors.today : Colors.grey[300]!,
            width: isToday ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CalendarColors.selected.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).weekdayShort(date.weekday),
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white70
                    : isWeekend
                    ? CalendarColors.weekend
                    : Colors.grey,
              ),
            ),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : isWeekend
                    ? CalendarColors.weekend
                    : null,
              ),
            ),
            if (events > 0)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : CalendarColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CircleLinePainter extends CustomPainter {
  final int dayCount;
  final double radius;
  final Color color;

  _CircleLinePainter({
    required this.dayCount,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw the connecting circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _CircleLinePainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}

/// Helper widget to rebuild on animation changes.
class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;

  const AnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
  }) : super();

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
