import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// A single day column that positions event blocks on a vertical time axis.
///
/// Used inside [WeekView] -- one instance per visible day.
class WeekDayColumn extends StatelessWidget {
  /// The date this column represents.
  final DateTime date;

  /// Events that occur on [date].
  final List<CalendarEvent> events;

  /// First visible hour (inclusive).
  final int startHour;

  /// Last visible hour (exclusive).
  final int endHour;

  /// Logical-pixel height of one hour slot.
  final double hourHeight;

  /// Called when the user taps on a specific time slot (empty area).
  final ValueChanged<DateTime>? onTimeTap;

  /// Called when the user taps an event.
  final ValueChanged<CalendarEvent>? onEventTap;

  const WeekDayColumn({
    super.key,
    required this.date,
    required this.events,
    this.startHour = 0,
    this.endHour = 24,
    this.hourHeight = 60.0,
    this.onTimeTap,
    this.onEventTap,
  });

  int get _totalHours => endHour - startHour;

  @override
  Widget build(BuildContext context) {
    final isToday = CalendarDateUtils.isSameDay(date, DateTime.now());
    final theme = Theme.of(context);

    return GestureDetector(
      onTapUp: (details) {
        if (onTimeTap != null) {
          final minutes =
              (details.localPosition.dy / hourHeight * 60).round() +
                  startHour * 60;
          final hour = (minutes ~/ 60).clamp(0, 23);
          final minute = (minutes % 60);
          final tappedTime = DateTime(
            date.year,
            date.month,
            date.day,
            hour,
            minute,
          );
          onTimeTap!(tappedTime);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? CalendarColors.today.withValues(alpha: 0.04)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
        ),
        child: SizedBox(
          height: _totalHours * hourHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: events.map((event) {
              final top = _topForTime(event.startTime);
              final height = _heightForEvent(event);
              return Positioned(
                top: top,
                left: 2,
                right: 2,
                height: height < 18 ? 18 : height,
                child: _EventBlock(
                  event: event,
                  onTap: onEventTap != null ? () => onEventTap!(event) : null,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  double _topForTime(DateTime time) {
    final totalMinutes = time.hour * 60 + time.minute;
    final startMinutes = startHour * 60;
    return (totalMinutes - startMinutes) * (hourHeight / 60);
  }

  double _heightForEvent(CalendarEvent event) {
    final durationMinutes = event.endTime.difference(event.startTime).inMinutes;
    return durationMinutes * (hourHeight / 60);
  }
}

/// Internal compact event block rendered inside a day column.
class _EventBlock extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;

  const _EventBlock({
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeData.estimateBrightnessForColor(event.color) ==
            Brightness.dark
        ? Colors.white
        : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: event.color.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: event.color,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
