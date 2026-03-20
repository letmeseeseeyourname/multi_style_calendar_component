import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import 'timeline_event.dart';

/// 时间线视图中的单个轨道（行）
class TimelineTrack extends StatelessWidget {
  /// 轨道标签
  final String trackLabel;

  /// 该轨道上的事件
  final List<CalendarEvent> events;

  /// 时间线起始日期
  final DateTime startDate;

  /// 时间线结束日期
  final DateTime endDate;

  /// 每天的像素宽度
  final double dayWidth;

  /// 轨道高度
  final double trackHeight;

  /// 是否偶数行（用于交替背景色）
  final bool isEven;

  /// 事件点击回调
  final ValueChanged<CalendarEvent>? onEventTap;

  const TimelineTrack({
    super.key,
    required this.trackLabel,
    required this.events,
    required this.startDate,
    required this.endDate,
    this.dayWidth = 40,
    this.trackHeight = 56,
    this.isEven = true,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = CalendarDateUtils.dateOnly(startDate);
    final totalDays = endDate.difference(startDate).inDays + 1;
    final today = CalendarDateUtils.dateOnly(DateTime.now());
    final todayOffset = today.difference(start).inDays;

    return Container(
      height: trackHeight,
      decoration: BoxDecoration(
        color: isEven
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 网格竖线
          ...List.generate(totalDays, (i) {
            final day = start.add(Duration(days: i));
            final isWeekStart = day.weekday == DateTime.monday;
            return Positioned(
              left: i * dayWidth,
              top: 0,
              bottom: 0,
              child: Container(
                width: 0.5,
                color: isWeekStart
                    ? theme.dividerColor.withValues(alpha: 0.4)
                    : theme.dividerColor.withValues(alpha: 0.15),
              ),
            );
          }),
          // 今日指示线
          if (todayOffset >= 0 && todayOffset < totalDays)
            Positioned(
              left: todayOffset * dayWidth + dayWidth / 2,
              top: 0,
              bottom: 0,
              child: Container(
                width: 2,
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
              ),
            ),
          // 事件条
          ...events.map((event) {
            final eventStart = CalendarDateUtils.dateOnly(event.startTime);
            final eventEnd = CalendarDateUtils.dateOnly(event.endTime);

            // Clamp to visible range
            final visibleStart = eventStart.isBefore(start) ? start : eventStart;
            final end = CalendarDateUtils.dateOnly(endDate);
            final visibleEnd = eventEnd.isAfter(end) ? end : eventEnd;

            final leftDays = visibleStart.difference(start).inDays;
            final widthDays = visibleEnd.difference(visibleStart).inDays + 1;

            if (leftDays < 0 || leftDays >= totalDays) return const SizedBox();

            return Positioned(
              left: leftDays * dayWidth + 2,
              top: 8,
              child: TimelineEvent(
                event: event,
                width: widthDays * dayWidth - 4,
                height: trackHeight - 16,
                onTap: () => onEventTap?.call(event),
              ),
            );
          }),
        ],
      ),
    );
  }
}
