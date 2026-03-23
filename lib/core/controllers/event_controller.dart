import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../utils/date_utils.dart';

/// Controller for managing calendar events (CRUD operations).
///
/// Stores events in memory and notifies listeners whenever the event
/// list changes. Use [getEventsForDate] or [getEventsForMonth] to
/// query events for display.
class EventController extends ChangeNotifier {
  final List<CalendarEvent> _events = [];

  List<CalendarEvent> get events => List.unmodifiable(_events);

  /// Returns all events that occur on [date], sorted by start time.
  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((e) => e.occursOn(date)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Returns all events that overlap with the given [year] and [month].
  List<CalendarEvent> getEventsForMonth(int year, int month) {
    return _events.where((e) {
      final startMonth = DateTime(e.startTime.year, e.startTime.month);
      final endMonth = DateTime(e.endTime.year, e.endTime.month);
      final targetMonth = DateTime(year, month);
      return !targetMonth.isBefore(startMonth) &&
          !targetMonth.isAfter(endMonth);
    }).toList();
  }

  /// Returns events grouped by date for the range from [start] to [end].
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

  /// Adds a new event to the list.
  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  /// Removes the event with the given [id].
  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Updates an existing event, matched by its [CalendarEvent.id].
  void updateEvent(CalendarEvent event) {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }

  /// Adds multiple events at once.
  void addAll(List<CalendarEvent> events) {
    _events.addAll(events);
    notifyListeners();
  }

  /// Removes all events.
  void clear() {
    _events.clear();
    notifyListeners();
  }
}
