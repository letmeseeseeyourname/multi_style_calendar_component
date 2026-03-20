import 'package:flutter/material.dart';

import '../../core/models/calendar_config.dart';
import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';
import 'week_day_column.dart';
import 'week_timeline.dart';

/// A full week view showing 7 day columns side by side with a shared time
/// ruler on the left.
///
/// The content is vertically scrollable so all hours are accessible even on
/// small screens.
class WeekView extends StatefulWidget {
  /// The start date of the week to display. If not aligned to the configured
  /// first day of week it will be adjusted automatically.
  final DateTime weekStart;

  /// Calendar configuration (hours range, first day of week, etc.).
  final CalendarConfig config;

  /// All events that may fall within this week.
  final List<CalendarEvent> events;

  /// Called when the user taps on an empty time slot.
  final ValueChanged<DateTime>? onTimeTap;

  /// Called when the user taps on an event.
  final ValueChanged<CalendarEvent>? onEventTap;

  const WeekView({
    super.key,
    required this.weekStart,
    this.config = const CalendarConfig(),
    this.events = const [],
    this.onTimeTap,
    this.onEventTap,
  });

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  late ScrollController _scrollController;

  static const double _hourHeight = 60.0;
  static const double _timeColumnWidth = 56.0;

  int get _startHour => widget.config.dayStartHour;
  int get _endHour => widget.config.dayEndHour;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _initialScrollOffset(),
    );
  }

  double _initialScrollOffset() {
    // Scroll so the current hour (or 8:00) is visible near the top.
    final now = DateTime.now();
    final targetHour = (now.hour - 1).clamp(_startHour, _endHour - 1);
    return (targetHour - _startHour) * _hourHeight;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adjustedStart = CalendarDateUtils.firstDayOfWeek(
      widget.weekStart,
      firstDay: widget.config.firstDayOfWeek,
    );
    final days =
        List.generate(7, (i) => adjustedStart.add(Duration(days: i)));

    return Column(
      children: [
        // Day header row
        _WeekDayHeader(
          days: days,
          timeColumnWidth: _timeColumnWidth,
        ),
        const Divider(height: 1),
        // Scrollable time grid
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              height: (_endHour - _startHour) * _hourHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time ruler (left column)
                  SizedBox(
                    width: _timeColumnWidth,
                    child: WeekTimeline(
                      startHour: _startHour,
                      endHour: _endHour,
                      hourHeight: _hourHeight,
                      timeColumnWidth: _timeColumnWidth,
                    ),
                  ),
                  // 7 day columns
                  ...days.map((day) {
                    final dayEvents = widget.events
                        .where((e) => e.occursOn(day))
                        .toList()
                      ..sort((a, b) =>
                          a.startTime.compareTo(b.startTime));
                    return Expanded(
                      child: WeekDayColumn(
                        date: day,
                        events: dayEvents,
                        startHour: _startHour,
                        endHour: _endHour,
                        hourHeight: _hourHeight,
                        onTimeTap: widget.onTimeTap,
                        onEventTap: widget.onEventTap,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sticky header showing day names and dates for the week.
class _WeekDayHeader extends StatelessWidget {
  final List<DateTime> days;
  final double timeColumnWidth;

  const _WeekDayHeader({
    required this.days,
    required this.timeColumnWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return SizedBox(
      height: 52,
      child: Row(
        children: [
          SizedBox(width: timeColumnWidth),
          ...days.map((day) {
            final isToday = CalendarDateUtils.isSameDay(day, now);
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CalendarDateUtils.weekdayName(day.weekday, short: true),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isToday
                          ? CalendarColors.today
                          : day.weekday >= 6
                              ? CalendarColors.weekend
                              : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isToday ? FontWeight.bold : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: isToday
                        ? const BoxDecoration(
                            color: CalendarColors.today,
                            shape: BoxShape.circle,
                          )
                        : null,
                    child: Text(
                      '${day.day}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isToday
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
