import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../utils/date_utils.dart';

/// 事件管理控制器
class EventController extends ChangeNotifier {
  final List<CalendarEvent> _events = [];

  List<CalendarEvent> get events => List.unmodifiable(_events);

  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((e) => e.occursOn(date)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<CalendarEvent> getEventsForMonth(int year, int month) {
    return _events.where((e) {
      final startMonth = DateTime(e.startTime.year, e.startTime.month);
      final endMonth = DateTime(e.endTime.year, e.endTime.month);
      final targetMonth = DateTime(year, month);
      return !targetMonth.isBefore(startMonth) &&
          !targetMonth.isAfter(endMonth);
    }).toList();
  }

  Map<DateTime, List<CalendarEvent>> getEventsGroupedByDate(
    DateTime start,
    DateTime end,
  ) {
    final map = <DateTime, List<CalendarEvent>>{};
    var current = CalendarDateUtils.dateOnly(start);
    final endDate = CalendarDateUtils.dateOnly(end);
    while (!current.isAfter(endDate)) {
      final dayEvents = getEventsForDate(current);
      if (dayEvents.isNotEmpty) {
        map[current] = dayEvents;
      }
      current = current.add(const Duration(days: 1));
    }
    return map;
  }

  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void updateEvent(CalendarEvent event) {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }

  void addAll(List<CalendarEvent> events) {
    _events.addAll(events);
    notifyListeners();
  }

  void clear() {
    _events.clear();
    notifyListeners();
  }
}
