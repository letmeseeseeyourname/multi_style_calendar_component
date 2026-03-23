import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calendar_collection/core/utils/date_utils.dart';
import 'package:flutter_calendar_collection/core/models/date_range.dart';
import 'package:flutter_calendar_collection/core/models/calendar_event.dart';
import 'package:flutter_calendar_collection/core/models/time_slot.dart';
import 'package:flutter_calendar_collection/core/models/calendar_config.dart';

void main() {
  // Test 1: CalendarDateUtils.isSameDay
  group('CalendarDateUtils.isSameDay', () {
    test('returns true for the same day with different times', () {
      final a = DateTime(2026, 3, 23, 10, 30);
      final b = DateTime(2026, 3, 23, 22, 15);
      expect(CalendarDateUtils.isSameDay(a, b), isTrue);
    });

    test('returns false for different days', () {
      final a = DateTime(2026, 3, 23);
      final b = DateTime(2026, 3, 24);
      expect(CalendarDateUtils.isSameDay(a, b), isFalse);
    });
  });

  // Test 2: CalendarDateUtils.daysInMonth
  group('CalendarDateUtils.daysInMonth', () {
    test('returns 31 for January', () {
      expect(CalendarDateUtils.daysInMonth(2026, 1), 31);
    });

    test('returns 28 for February in a non-leap year', () {
      expect(CalendarDateUtils.daysInMonth(2025, 2), 28);
    });

    test('returns 29 for February in a leap year', () {
      expect(CalendarDateUtils.daysInMonth(2024, 2), 29);
    });

    test('returns 30 for April', () {
      expect(CalendarDateUtils.daysInMonth(2026, 4), 30);
    });
  });

  // Test 3: CalendarDateUtils.firstDayOfMonth / lastDayOfMonth
  group('CalendarDateUtils.firstDayOfMonth and lastDayOfMonth', () {
    test('firstDayOfMonth returns the 1st of the month', () {
      final date = DateTime(2026, 3, 23);
      final first = CalendarDateUtils.firstDayOfMonth(date);
      expect(first, DateTime(2026, 3, 1));
    });

    test('lastDayOfMonth returns the last day of the month', () {
      final date = DateTime(2026, 2, 10);
      final last = CalendarDateUtils.lastDayOfMonth(date);
      expect(last.day, 28);
      expect(last.month, 2);
    });

    test('lastDayOfMonth handles leap year February', () {
      final date = DateTime(2024, 2, 5);
      final last = CalendarDateUtils.lastDayOfMonth(date);
      expect(last.day, 29);
    });
  });

  // Test 4: CalendarDateUtils.daysInMonthGrid
  group('CalendarDateUtils.daysInMonthGrid', () {
    test('returns exactly 42 days', () {
      final grid = CalendarDateUtils.daysInMonthGrid(DateTime(2026, 3, 1));
      expect(grid.length, 42);
    });

    test('first day of grid is a Monday when firstDayOfWeek is 1', () {
      final grid = CalendarDateUtils.daysInMonthGrid(
        DateTime(2026, 3, 1),
        firstDayOfWeek: 1,
      );
      // The first element should be a Monday (weekday == 1)
      expect(grid.first.weekday, DateTime.monday);
    });

    test('first day of grid is a Sunday when firstDayOfWeek is 7', () {
      final grid = CalendarDateUtils.daysInMonthGrid(
        DateTime(2026, 3, 1),
        firstDayOfWeek: 7,
      );
      expect(grid.first.weekday, DateTime.sunday);
    });

    test('grid contains the 1st of the target month', () {
      final month = DateTime(2026, 3, 1);
      final grid = CalendarDateUtils.daysInMonthGrid(month);
      expect(
        grid.any((d) => d.year == 2026 && d.month == 3 && d.day == 1),
        isTrue,
      );
    });
  });

  // Test 5: CalendarDateUtils.firstDayOfWeek
  group('CalendarDateUtils.firstDayOfWeek', () {
    test('with Monday start, returns previous Monday', () {
      // 2026-03-23 is a Monday
      final wednesday = DateTime(2026, 3, 25); // Wednesday
      final result = CalendarDateUtils.firstDayOfWeek(wednesday, firstDay: 1);
      expect(result, DateTime(2026, 3, 23));
      expect(result.weekday, DateTime.monday);
    });

    test('with Sunday start, returns previous Sunday', () {
      final wednesday = DateTime(2026, 3, 25); // Wednesday
      final result = CalendarDateUtils.firstDayOfWeek(wednesday, firstDay: 7);
      expect(result, DateTime(2026, 3, 22));
      expect(result.weekday, DateTime.sunday);
    });

    test('returns same day if already the first day of the week', () {
      final monday = DateTime(2026, 3, 23);
      final result = CalendarDateUtils.firstDayOfWeek(monday, firstDay: 1);
      expect(result, DateTime(2026, 3, 23));
    });
  });

  // Test 6: DateRange.contains
  group('DateRange.contains', () {
    final range = DateRange(DateTime(2026, 3, 10), DateTime(2026, 3, 20));

    test('returns true for a date inside the range', () {
      expect(range.contains(DateTime(2026, 3, 15)), isTrue);
    });

    test('returns true for the start boundary', () {
      expect(range.contains(DateTime(2026, 3, 10)), isTrue);
    });

    test('returns true for the end boundary', () {
      expect(range.contains(DateTime(2026, 3, 20)), isTrue);
    });

    test('returns false for a date before the range', () {
      expect(range.contains(DateTime(2026, 3, 9)), isFalse);
    });

    test('returns false for a date after the range', () {
      expect(range.contains(DateTime(2026, 3, 21)), isFalse);
    });
  });

  // Test 7: DateRange.dayCount
  group('DateRange.dayCount', () {
    test('returns correct day count for a multi-day range', () {
      final range = DateRange(DateTime(2026, 3, 10), DateTime(2026, 3, 20));
      expect(range.dayCount, 11);
    });

    test('returns 1 for a single-day range', () {
      final range = DateRange(DateTime(2026, 3, 10), DateTime(2026, 3, 10));
      expect(range.dayCount, 1);
    });
  });

  // Test 8: CalendarEvent.occursOn
  group('CalendarEvent.occursOn', () {
    test('single-day event occurs on its own day', () {
      final event = CalendarEvent(
        id: '1',
        title: 'Meeting',
        startTime: DateTime(2026, 3, 23, 10, 0),
        endTime: DateTime(2026, 3, 23, 11, 0),
      );
      expect(event.occursOn(DateTime(2026, 3, 23)), isTrue);
    });

    test('single-day event does not occur on a different day', () {
      final event = CalendarEvent(
        id: '1',
        title: 'Meeting',
        startTime: DateTime(2026, 3, 23, 10, 0),
        endTime: DateTime(2026, 3, 23, 11, 0),
      );
      expect(event.occursOn(DateTime(2026, 3, 24)), isFalse);
    });

    test('multi-day non-allDay event occurs on start and end days', () {
      final event = CalendarEvent(
        id: '2',
        title: 'Conference',
        startTime: DateTime(2026, 3, 23, 9, 0),
        endTime: DateTime(2026, 3, 25, 17, 0),
      );
      expect(event.occursOn(DateTime(2026, 3, 23)), isTrue);
      expect(event.occursOn(DateTime(2026, 3, 25)), isTrue);
      // Non-allDay multi-day events only match start and end days
      expect(event.occursOn(DateTime(2026, 3, 24)), isFalse);
    });

    test('allDay multi-day event occurs on intermediate days', () {
      final event = CalendarEvent(
        id: '3',
        title: 'Vacation',
        startTime: DateTime(2026, 3, 23),
        endTime: DateTime(2026, 3, 25),
        isAllDay: true,
      );
      expect(event.occursOn(DateTime(2026, 3, 23)), isTrue);
      expect(event.occursOn(DateTime(2026, 3, 24)), isTrue);
      expect(event.occursOn(DateTime(2026, 3, 25)), isTrue);
      expect(event.occursOn(DateTime(2026, 3, 26)), isFalse);
    });
  });

  // Test 9: CalendarEvent.isMultiDay and duration
  group('CalendarEvent.isMultiDay and duration', () {
    test('isMultiDay is false for same-day event', () {
      final event = CalendarEvent(
        id: '1',
        title: 'Quick call',
        startTime: DateTime(2026, 3, 23, 10, 0),
        endTime: DateTime(2026, 3, 23, 10, 30),
      );
      expect(event.isMultiDay, isFalse);
    });

    test('isMultiDay is true for cross-day event', () {
      final event = CalendarEvent(
        id: '2',
        title: 'Trip',
        startTime: DateTime(2026, 3, 23),
        endTime: DateTime(2026, 3, 25),
      );
      expect(event.isMultiDay, isTrue);
    });

    test('duration returns correct time difference', () {
      final event = CalendarEvent(
        id: '3',
        title: 'Workshop',
        startTime: DateTime(2026, 3, 23, 9, 0),
        endTime: DateTime(2026, 3, 23, 12, 30),
      );
      expect(event.duration, const Duration(hours: 3, minutes: 30));
    });
  });

  // Test 10: TimeSlot.overlaps
  group('TimeSlot.overlaps', () {
    test('returns true for overlapping slots', () {
      final a = TimeSlot(
        start: DateTime(2026, 3, 23, 10, 0),
        end: DateTime(2026, 3, 23, 12, 0),
      );
      final b = TimeSlot(
        start: DateTime(2026, 3, 23, 11, 0),
        end: DateTime(2026, 3, 23, 13, 0),
      );
      expect(a.overlaps(b), isTrue);
      expect(b.overlaps(a), isTrue);
    });

    test('returns false for non-overlapping slots', () {
      final a = TimeSlot(
        start: DateTime(2026, 3, 23, 10, 0),
        end: DateTime(2026, 3, 23, 11, 0),
      );
      final b = TimeSlot(
        start: DateTime(2026, 3, 23, 12, 0),
        end: DateTime(2026, 3, 23, 13, 0),
      );
      expect(a.overlaps(b), isFalse);
    });

    test('returns false for adjacent slots (end == start)', () {
      final a = TimeSlot(
        start: DateTime(2026, 3, 23, 10, 0),
        end: DateTime(2026, 3, 23, 11, 0),
      );
      final b = TimeSlot(
        start: DateTime(2026, 3, 23, 11, 0),
        end: DateTime(2026, 3, 23, 12, 0),
      );
      expect(a.overlaps(b), isFalse);
    });
  });

  // Test 11: CalendarConfig.copyWith
  group('CalendarConfig.copyWith', () {
    test('preserves unchanged values when changing one field', () {
      const original = CalendarConfig();
      final modified = original.copyWith(viewType: CalendarViewType.week);

      expect(modified.viewType, CalendarViewType.week);
      // All other fields should remain at their defaults
      expect(modified.system, CalendarSystem.gregorian);
      expect(modified.firstDayOfWeek, 1);
      expect(modified.showLunar, isTrue);
      expect(modified.showHolidays, isTrue);
      expect(modified.selectionMode, SelectionMode.single);
      expect(modified.enableDrag, isFalse);
      expect(modified.enableCreate, isTrue);
      expect(modified.dayStartHour, 0);
      expect(modified.dayEndHour, 24);
      expect(modified.timeSlotMinutes, 30);
    });

    test('can change multiple fields at once', () {
      const original = CalendarConfig();
      final modified = original.copyWith(
        selectionMode: SelectionMode.range,
        showLunar: false,
        firstDayOfWeek: 7,
      );

      expect(modified.selectionMode, SelectionMode.range);
      expect(modified.showLunar, isFalse);
      expect(modified.firstDayOfWeek, 7);
      // Unchanged fields preserved
      expect(modified.system, CalendarSystem.gregorian);
      expect(modified.viewType, CalendarViewType.month);
    });
  });
}
