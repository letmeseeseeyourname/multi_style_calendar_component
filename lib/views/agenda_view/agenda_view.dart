import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import 'agenda_group.dart';
import 'agenda_item.dart';

/// 日程列表视图 - 按日期分组展示事件
class AgendaView extends StatelessWidget {
  /// 要显示的事件列表
  final List<CalendarEvent> events;

  /// 显示的日期范围起始日
  final DateTime startDate;

  /// 显示的天数
  final int daysToShow;

  /// 点击事件的回调
  final ValueChanged<CalendarEvent>? onEventTap;

  /// 点击日期的回调
  final ValueChanged<DateTime>? onDateTap;

  /// 是否显示空日期（没有事件的日期）
  final bool showEmptyDates;

  /// 滚动控制器
  final ScrollController? scrollController;

  const AgendaView({
    super.key,
    required this.events,
    required this.startDate,
    this.daysToShow = 30,
    this.onEventTap,
    this.onDateTap,
    this.showEmptyDates = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final groupedData = _buildGroupedData();

    if (groupedData.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        final entry = groupedData[index];
        final date = entry.key;
        final dayEvents = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AgendaGroup(
              date: date,
              eventCount: dayEvents.length,
              onTap: () => onDateTap?.call(date),
            ),
            if (dayEvents.isEmpty)
              _buildNoEvents(context)
            else
              ...dayEvents.map(
                (event) => AgendaItem(
                  event: event,
                  onTap: () => onEventTap?.call(event),
                ),
              ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  List<MapEntry<DateTime, List<CalendarEvent>>> _buildGroupedData() {
    final result = <MapEntry<DateTime, List<CalendarEvent>>>[];
    final start = CalendarDateUtils.dateOnly(startDate);

    for (int i = 0; i < daysToShow; i++) {
      final date = start.add(Duration(days: i));
      final dayEvents = events.where((e) => e.occursOn(date)).toList()
        ..sort((a, b) {
          if (a.isAllDay && !b.isAllDay) return -1;
          if (!a.isAllDay && b.isAllDay) return 1;
          return a.startTime.compareTo(b.startTime);
        });

      if (dayEvents.isNotEmpty || showEmptyDates) {
        result.add(MapEntry(date, dayEvents));
      }
    }

    return result;
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: theme.hintColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noSchedule,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildNoEvents(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 52, top: 4, bottom: 4),
      child: Text(
        AppLocalizations.of(context).noEventsShort,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.hintColor,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
