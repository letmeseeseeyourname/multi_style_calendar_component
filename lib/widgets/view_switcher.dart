import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

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

  static const _viewIcons = <CalendarViewType, IconData>{
    CalendarViewType.year: Icons.calendar_view_month,
    CalendarViewType.month: Icons.calendar_month,
    CalendarViewType.week: Icons.calendar_view_week,
    CalendarViewType.day: Icons.calendar_view_day,
    CalendarViewType.agenda: Icons.view_agenda,
    CalendarViewType.timeline: Icons.timeline,
  };

  static Map<CalendarViewType, String> _viewLabels(AppLocalizations l) {
    return {
      CalendarViewType.year: l.yearLabel,
      CalendarViewType.month: l.monthLabel,
      CalendarViewType.week: l.weekLabel,
      CalendarViewType.day: l.dayLabel,
      CalendarViewType.agenda: l.agendaLabel,
      CalendarViewType.timeline: l.timelineLabel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = _viewLabels(l);

    return SegmentedButton<CalendarViewType>(
      segments: availableViews.map((view) {
        return ButtonSegment<CalendarViewType>(
          value: view,
          label: Text(labels[view] ?? view.name),
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
