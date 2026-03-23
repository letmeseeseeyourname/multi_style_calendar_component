import 'package:flutter/material.dart';

/// A calendar event with a time range, color, and optional recurrence.
///
/// Supports all-day events, multi-day events, repeating rules, and
/// reminders. Use [occursOn] to check whether the event falls on a given date.
class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;

  final Color color;
  final String? icon;
  final EventRepeat? repeat;
  final EventReminder? reminder;

  final String? location;
  final List<String>? attendees;
  final String? createdBy;

  final Map<String, dynamic>? extra;

  const CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.isAllDay = false,
    this.color = Colors.blue,
    this.icon,
    this.repeat,
    this.reminder,
    this.location,
    this.attendees,
    this.createdBy,
    this.extra,
  });

  /// The duration of the event from start to end.
  Duration get duration => endTime.difference(startTime);

  /// Whether the event spans more than one calendar day.
  bool get isMultiDay {
    return startTime.year != endTime.year ||
        startTime.month != endTime.month ||
        startTime.day != endTime.day;
  }

  /// Returns `true` if this event occurs on the given [date].
  bool occursOn(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(startTime.year, startTime.month, startTime.day);
    final endOnly = DateTime(endTime.year, endTime.month, endTime.day);

    if (isAllDay) {
      return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
    }
    return dateOnly == startOnly || dateOnly == endOnly;
  }

  CalendarEvent copyWith({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    Color? color,
    String? location,
  }) {
    return CalendarEvent(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      color: color ?? this.color,
      icon: icon,
      repeat: repeat,
      reminder: reminder,
      location: location ?? this.location,
      attendees: attendees,
      createdBy: createdBy,
      extra: extra,
    );
  }
}

/// Defines a recurrence rule for a calendar event.
///
/// Supports daily, weekly, monthly, and yearly repetition with an optional
/// end date or maximum number of occurrences.
class EventRepeat {
  final RepeatType type;
  final int interval;
  final List<int>? weekdays;
  final int? dayOfMonth;
  final DateTime? endDate;
  final int? occurrences;

  const EventRepeat({
    required this.type,
    this.interval = 1,
    this.weekdays,
    this.dayOfMonth,
    this.endDate,
    this.occurrences,
  });
}

enum RepeatType { daily, weekly, monthly, yearly }

/// Reminder settings for a calendar event.
class EventReminder {
  final Duration beforeEvent;
  final String? message;

  const EventReminder({required this.beforeEvent, this.message});
}
