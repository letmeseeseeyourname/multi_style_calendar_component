import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../core/utils/date_utils.dart';
import 'timeline_track.dart';

/// 甘特图风格的水平时间线视图
class TimelineView extends StatefulWidget {
  /// 事件列表
  final List<CalendarEvent> events;

  /// 时间线起始日期
  final DateTime startDate;

  /// 时间线结束日期
  final DateTime endDate;

  /// 轨道分类标签（按 category 分组事件）
  /// 如果为空，按事件的 createdBy 或自动分组
  final List<String>? trackLabels;

  /// 每天对应的像素宽度
  final double dayWidth;

  /// 每个轨道的高度
  final double trackHeight;

  /// 点击事件回调
  final ValueChanged<CalendarEvent>? onEventTap;

  /// 点击日期回调
  final ValueChanged<DateTime>? onDateTap;

  const TimelineView({
    super.key,
    required this.events,
    required this.startDate,
    required this.endDate,
    this.trackLabels,
    this.dayWidth = 40,
    this.trackHeight = 56,
    this.onEventTap,
    this.onDateTap,
  });

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  int get _totalDays =>
      widget.endDate.difference(widget.startDate).inDays + 1;

  double get _totalWidth => _totalDays * widget.dayWidth;

  Map<String, List<CalendarEvent>> get _groupedEvents {
    final groups = <String, List<CalendarEvent>>{};

    if (widget.trackLabels != null) {
      for (final label in widget.trackLabels!) {
        groups[label] = [];
      }
    }

    for (final event in widget.events) {
      final key = event.createdBy ?? event.extra?['category'] ?? '默认';
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(event);
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = _groupedEvents;
    final trackEntries = groups.entries.toList();

    return Column(
      children: [
        // 日期头部（水平滚动）
        SizedBox(
          height: 52,
          child: Row(
            children: [
              // 左侧标签列占位
              Container(
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: theme.dividerColor),
                    right: BorderSide(color: theme.dividerColor),
                  ),
                ),
                child: Text(
                  '分类',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // 日期标题
              Expanded(
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: _buildDateHeaders(theme),
                ),
              ),
            ],
          ),
        ),
        // 轨道区域
        Expanded(
          child: Row(
            children: [
              // 左侧标签列
              SizedBox(
                width: 100,
                child: ListView.builder(
                  controller: _verticalController,
                  itemCount: trackEntries.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: widget.trackHeight,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor.withValues(alpha: 0.3),
                          ),
                          right: BorderSide(color: theme.dividerColor),
                        ),
                        color: index.isEven
                            ? theme.colorScheme.surface
                            : theme.colorScheme.surfaceContainerLowest,
                      ),
                      child: Text(
                        trackEntries[index].key,
                        style: theme.textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
              // 甘特图主区域
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    // 同步水平滚动
                    return false;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _horizontalController,
                    child: SizedBox(
                      width: _totalWidth,
                      child: ListView.builder(
                        itemCount: trackEntries.length,
                        itemBuilder: (context, index) {
                          final entry = trackEntries[index];
                          return TimelineTrack(
                            trackLabel: entry.key,
                            events: entry.value,
                            startDate: widget.startDate,
                            endDate: widget.endDate,
                            dayWidth: widget.dayWidth,
                            trackHeight: widget.trackHeight,
                            isEven: index.isEven,
                            onEventTap: widget.onEventTap,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateHeaders(ThemeData theme) {
    final start = CalendarDateUtils.dateOnly(widget.startDate);
    final today = CalendarDateUtils.dateOnly(DateTime.now());

    return SizedBox(
      width: _totalWidth,
      height: 52,
      child: Stack(
        children: [
          // 月份行
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 24,
            child: Row(
              children: _buildMonthHeaders(theme, start),
            ),
          ),
          // 日期行
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 28,
            child: Row(
              children: List.generate(_totalDays, (i) {
                final day = start.add(Duration(days: i));
                final isToday = day == today;
                final isWeekend = day.weekday == DateTime.saturday ||
                    day.weekday == DateTime.sunday;

                return GestureDetector(
                  onTap: () => widget.onDateTap?.call(day),
                  child: Container(
                    width: widget.dayWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : null,
                      border: Border(
                        bottom: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                    child: Text(
                      '${day.day}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: isToday ? FontWeight.bold : null,
                        color: isToday
                            ? theme.colorScheme.primary
                            : isWeekend
                                ? theme.hintColor.withValues(alpha: 0.5)
                                : theme.hintColor,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMonthHeaders(ThemeData theme, DateTime start) {
    final headers = <Widget>[];
    int i = 0;
    while (i < _totalDays) {
      final day = start.add(Duration(days: i));
      int daysInThisMonth = 0;
      final month = day.month;
      final year = day.year;

      while (i + daysInThisMonth < _totalDays) {
        final d = start.add(Duration(days: i + daysInThisMonth));
        if (d.month != month || d.year != year) break;
        daysInThisMonth++;
      }

      headers.add(
        Container(
          width: daysInThisMonth * widget.dayWidth,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
              right: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
            ),
          ),
          child: Text(
            '${year}年${CalendarDateUtils.monthName(month)}',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

      i += daysInThisMonth;
    }
    return headers;
  }
}
