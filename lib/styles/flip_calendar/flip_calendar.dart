import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/color_schemes.dart';

/// 3D flip page calendar showing current date with flip animation to change.
/// Displays a desk-calendar style widget with day, month, year, and weekday.
class FlipCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateChanged;
  final double width;
  final double height;

  const FlipCalendar({
    super.key,
    this.initialDate,
    this.onDateChanged,
    this.width = 280,
    this.height = 340,
  });

  @override
  State<FlipCalendar> createState() => _FlipCalendarState();
}

class _FlipCalendarState extends State<FlipCalendar>
    with TickerProviderStateMixin {
  late DateTime _currentDate;
  late DateTime _previousDate;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate ?? DateTime.now();
    _previousDate = _currentDate;
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
          _previousDate = _currentDate;
        });
        _flipController.reset();
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _goToDate(DateTime date) {
    if (_isFlipping) return;
    setState(() {
      _previousDate = _currentDate;
      _currentDate = date;
      _isFlipping = true;
    });
    _flipController.forward(from: 0);
    widget.onDateChanged?.call(date);
  }

  void _previousDay() {
    _goToDate(_currentDate.subtract(const Duration(days: 1)));
  }

  void _nextDay() {
    _goToDate(_currentDate.add(const Duration(days: 1)));
  }

  void _goToToday() {
    _goToDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The flip card
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            if (details.primaryVelocity! < 0) {
              _nextDay();
            } else {
              _previousDay();
            }
          },
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: AnimatedBuilder(
              listenable: _flipAnimation,
              builder: (context, _) {
                final angle = _flipAnimation.value;
                final showPrevious = angle < math.pi / 2;

                return Stack(
                  children: [
                    // Bottom card (new date) - always visible behind
                    _buildDateCard(context, _currentDate, isBackground: true),
                    // Top card (flipping) with 3D transform
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(showPrevious ? angle : angle - math.pi),
                      child: showPrevious
                          ? _buildDateCard(context, _previousDate)
                          : _buildDateCard(context, _currentDate),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavButton(
              icon: Icons.chevron_left,
              onTap: _previousDay,
            ),
            const SizedBox(width: 8),
            _NavButton(
              icon: Icons.today,
              label: AppLocalizations.of(context).today,
              onTap: _goToToday,
            ),
            const SizedBox(width: 8),
            _NavButton(
              icon: Icons.chevron_right,
              onTap: _nextDay,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateCard(BuildContext context, DateTime date, {bool isBackground = false}) {
    final l = AppLocalizations.of(context);
    final monthName = l.monthName(date.month);
    final weekday = l.weekdayLong(date.weekday);
    final isToday = CalendarDateUtils.isSameDay(date, DateTime.now());

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isBackground
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Top color bar with month
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isToday ? CalendarColors.today : CalendarColors.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(19),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '${date.year}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  monthName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Large day number
          Expanded(
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey[800],
                  height: 1,
                ),
              ),
            ),
          ),
          // Weekday
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(19),
              ),
            ),
            child: Text(
              weekday,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: (date.weekday == DateTime.saturday ||
                        date.weekday == DateTime.sunday)
                    ? CalendarColors.weekend
                    : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: label != null ? 16 : 12,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: Colors.grey[700]),
              if (label != null) ...[
                const SizedBox(width: 4),
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
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
