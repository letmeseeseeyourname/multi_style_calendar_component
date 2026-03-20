import 'package:flutter/material.dart';

import '../../core/models/calendar_config.dart';
import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/color_schemes.dart';
import 'event_card.dart';
import 'hour_row.dart';
import 'time_indicator.dart';

/// A full-day view with a vertically scrollable 24-hour (configurable) time
/// grid.
///
/// Events are positioned on the timeline according to their start/end times.
/// A red current-time indicator is shown when [date] is today.
class DayView extends StatefulWidget {
  /// The date to display.
  final DateTime date;

  /// Calendar configuration (hour range, etc.).
  final CalendarConfig config;

  /// Events occurring on [date].
  final List<CalendarEvent> events;

  /// Called when the user taps on an empty time slot.
  final ValueChanged<DateTime>? onTimeTap;

  /// Called when the user taps on an event card.
  final ValueChanged<CalendarEvent>? onEventTap;

  const DayView({
    super.key,
    required this.date,
    this.config = const CalendarConfig(),
    this.events = const [],
    this.onTimeTap,
    this.onEventTap,
  });

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  late ScrollController _scrollController;

  static const double _hourHeight = 60.0;
  static const double _timeColumnWidth = 56.0;

  int get _startHour => widget.config.dayStartHour;
  int get _endHour => widget.config.dayEndHour;
  int get _totalHours => _endHour - _startHour;
  double get _totalHeight => _totalHours * _hourHeight;

  bool get _isToday => CalendarDateUtils.isSameDay(widget.date, DateTime.now());

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _initialScrollOffset(),
    );
  }

  double _initialScrollOffset() {
    final now = DateTime.now();
    final targetHour = (_isToday ? now.hour - 1 : 8).clamp(_startHour, _endHour - 1);
    return (targetHour - _startHour) * _hourHeight;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Day header
        _DayHeader(date: widget.date, isToday: _isToday),
        const Divider(height: 1),
        // Scrollable timeline
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: GestureDetector(
              onTapUp: (details) {
                if (widget.onTimeTap != null) {
                  final minutes =
                      (details.localPosition.dy / _hourHeight * 60).round() +
                          _startHour * 60;
                  final hour = (minutes ~/ 60).clamp(0, 23);
                  final minute = minutes % 60;
                  widget.onTimeTap!(DateTime(
                    widget.date.year,
                    widget.date.month,
                    widget.date.day,
                    hour,
                    minute,
                  ));
                }
              },
              child: SizedBox(
                height: _totalHeight,
                child: Stack(
                  children: [
                    // Hour grid rows
                    ...List.generate(_totalHours, (i) {
                      return Positioned(
                        top: i * _hourHeight,
                        left: 0,
                        right: 0,
                        height: _hourHeight,
                        child: HourRow(
                          hour: _startHour + i,
                          top: i * _hourHeight,
                          hourHeight: _hourHeight,
                          timeColumnWidth: _timeColumnWidth,
                        ),
                      );
                    }),
                    // Event cards
                    ..._buildEventCards(),
                    // Current time indicator
                    if (_isToday) _buildTimeIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildEventCards() {
    final sorted = [...widget.events]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return sorted.map((event) {
      final top = _topForTime(event.startTime);
      final height = _heightForEvent(event);

      return Positioned(
        top: top,
        left: _timeColumnWidth + 4,
        right: 4,
        height: height < 22 ? 22 : height,
        child: EventCard(
          event: event,
          onTap: widget.onEventTap != null
              ? () => widget.onEventTap!(event)
              : null,
        ),
      );
    }).toList();
  }

  Widget _buildTimeIndicator() {
    final now = DateTime.now();
    final top = _topForTime(now);
    return TimeIndicator(
      top: top,
      timeColumnWidth: _timeColumnWidth,
    );
  }

  double _topForTime(DateTime time) {
    final totalMinutes = time.hour * 60 + time.minute;
    final startMinutes = _startHour * 60;
    return (totalMinutes - startMinutes) * (_hourHeight / 60);
  }

  double _heightForEvent(CalendarEvent event) {
    final durationMinutes = event.endTime.difference(event.startTime).inMinutes;
    return durationMinutes * (_hourHeight / 60);
  }
}

/// Simple header showing the full date.
class _DayHeader extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const _DayHeader({required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: isToday
                ? const BoxDecoration(
                    color: CalendarColors.today,
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              '${date.day}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isToday ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.weekdayLong(date.weekday),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isToday
                      ? CalendarColors.today
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isToday ? FontWeight.w600 : null,
                ),
              ),
              Text(
                l.yearMonthDay(date.year, date.month, date.day),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CalendarColors.today.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l.today,
                style: const TextStyle(
                  color: CalendarColors.today,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
