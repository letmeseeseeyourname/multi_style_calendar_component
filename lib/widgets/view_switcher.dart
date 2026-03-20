import 'package:flutter/material.dart';

import '../core/models/calendar_config.dart';

/// Segmented button to switch between calendar view types.
class ViewSwitcher extends StatelessWidget {
  final CalendarViewType currentView;
  final ValueChanged<CalendarViewType> onViewChanged;
  final List<CalendarViewType> availableViews;

  const ViewSwitcher({
    super.key,
    required this.currentView,
    required this.onViewChanged,
    this.availableViews = const [
      CalendarViewType.year,
      CalendarViewType.month,
      CalendarViewType.week,
      CalendarViewType.day,
      CalendarViewType.agenda,
    ],
  });

  static const _viewLabels = <CalendarViewType, String>{
    CalendarViewType.year: '年',
    CalendarViewType.month: '月',
    CalendarViewType.week: '周',
    CalendarViewType.day: '日',
    CalendarViewType.agenda: '日程',
    CalendarViewType.timeline: '时间线',
  };

  static const _viewIcons = <CalendarViewType, IconData>{
    CalendarViewType.year: Icons.calendar_view_month,
    CalendarViewType.month: Icons.calendar_month,
    CalendarViewType.week: Icons.calendar_view_week,
    CalendarViewType.day: Icons.calendar_view_day,
    CalendarViewType.agenda: Icons.view_agenda,
    CalendarViewType.timeline: Icons.timeline,
  };

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<CalendarViewType>(
      segments: availableViews.map((view) {
        return ButtonSegment<CalendarViewType>(
          value: view,
          label: Text(_viewLabels[view] ?? view.name),
          icon: Icon(_viewIcons[view] ?? Icons.calendar_today, size: 18),
        );
      }).toList(),
      selected: {currentView},
      onSelectionChanged: (selected) {
        if (selected.isNotEmpty) {
          onViewChanged(selected.first);
        }
      },
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
