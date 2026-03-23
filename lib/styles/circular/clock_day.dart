import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/calendar_event.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/color_schemes.dart';

/// Clock-style day view: 12/24 hour positions around a circle
/// showing events as colored arcs.
class ClockDayView extends StatefulWidget {
  final DateTime date;
  final List<CalendarEvent> events;
  final bool use24Hour;
  final double size;
  final ValueChanged<CalendarEvent>? onEventTap;

  const ClockDayView({
    super.key,
    required this.date,
    this.events = const [],
    this.use24Hour = true,
    this.size = 320,
    this.onEventTap,
  });

  @override
  State<ClockDayView> createState() => _ClockDayViewState();
}

class _ClockDayViewState extends State<ClockDayView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final totalHours = widget.use24Hour ? 24 : 12;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            l.yearMonthDay(
              widget.date.year,
              widget.date.month,
              widget.date.day,
            ),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Clock face
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            listenable: _animController,
            builder: (context, _) {
              final progress = CurvedAnimation(
                parent: _animController,
                curve: Curves.easeOutCubic,
              ).value;

              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ClockFacePainter(
                  totalHours: totalHours,
                  events: widget.events,
                  date: widget.date,
                  progress: progress,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Center info
                    _buildCenterInfo(context, theme),
                    // Hour labels
                    ...List.generate(totalHours, (i) {
                      final hour = widget.use24Hour ? i : (i == 0 ? 12 : i);
                      final angle =
                          (2 * math.pi / totalHours) * i - math.pi / 2;
                      final radius = widget.size / 2 - 24;
                      final dx = radius * math.cos(angle);
                      final dy = radius * math.sin(angle);

                      return Transform.translate(
                        offset: Offset(dx, dy),
                        child: Text(
                          '$hour',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        // Event legend
        if (widget.events.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildEventLegend(theme),
        ],
      ],
    );
  }

  Widget _buildCenterInfo(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    final isToday =
        widget.date.year == now.year &&
        widget.date.month == now.month &&
        widget.date.day == now.day;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${widget.date.day}',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: CalendarColors.primary,
          ),
        ),
        if (isToday)
          Text(
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        Text(
          l.nEvents(widget.events.length),
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEventLegend(ThemeData theme) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: widget.events.map((event) {
        final startH = event.startTime.hour;
        final startM = event.startTime.minute;
        final endH = event.endTime.hour;
        final endM = event.endTime.minute;
        return GestureDetector(
          onTap: () => widget.onEventTap?.call(event),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${event.title} '
                '${startH.toString().padLeft(2, '0')}:${startM.toString().padLeft(2, '0')}'
                '-${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ClockFacePainter extends CustomPainter {
  final int totalHours;
  final List<CalendarEvent> events;
  final DateTime date;
  final double progress;

  _ClockFacePainter({
    required this.totalHours,
    required this.events,
    required this.date,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 40;
    final innerRadius = outerRadius - 30;

    // Draw clock face circle
    final facePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, outerRadius, facePaint);

    // Draw outer ring
    final ringPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, outerRadius, ringPaint);
    canvas.drawCircle(center, innerRadius, ringPaint);

    // Draw hour tick marks
    final tickPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    for (int i = 0; i < totalHours; i++) {
      final angle = (2 * math.pi / totalHours) * i - math.pi / 2;
      final outer = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (outerRadius - 6) * math.cos(angle),
        center.dy + (outerRadius - 6) * math.sin(angle),
      );
      canvas.drawLine(outer, inner, tickPaint);
    }

    // Draw event arcs
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      final startMinutes = event.startTime.hour * 60 + event.startTime.minute;
      final endMinutes = event.endTime.hour * 60 + event.endTime.minute;
      final totalMinutes = totalHours * 60;

      final startAngle =
          (2 * math.pi * startMinutes / totalMinutes) - math.pi / 2;
      final sweepAngle =
          (2 * math.pi * (endMinutes - startMinutes) / totalMinutes) * progress;

      final arcRadius = innerRadius - 4 - (i * 8);
      if (arcRadius < 30) continue;

      final arcPaint = Paint()
        ..color = event.color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: arcRadius),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }

    // Draw current time hand if date is today
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      final nowMinutes = now.hour * 60 + now.minute;
      final totalMinutes = totalHours * 60;
      final angle = (2 * math.pi * nowMinutes / totalMinutes) - math.pi / 2;

      final handPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      final handEnd = Offset(
        center.dx + (innerRadius - 10) * math.cos(angle),
        center.dy + (innerRadius - 10) * math.sin(angle),
      );
      canvas.drawLine(center, handEnd, handPaint);
      canvas.drawCircle(center, 4, Paint()..color = Colors.red);
    }
  }

  @override
  bool shouldRepaint(covariant _ClockFacePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.date != date;
  }
}

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
