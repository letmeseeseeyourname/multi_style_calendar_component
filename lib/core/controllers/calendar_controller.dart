import 'package:flutter/material.dart';
import '../models/calendar_config.dart';
import '../calendar_system/gregorian_calendar.dart';

/// Core controller that manages the current date and view type for the calendar.
///
/// Provides navigation methods to move between days, weeks, months, and years,
/// and notifies listeners on every change.
class CalendarController extends ChangeNotifier {
  DateTime _currentDate;
  CalendarViewType _viewType;

  CalendarController({
    DateTime? initialDate,
    CalendarViewType viewType = CalendarViewType.month,
  }) : _currentDate = initialDate ?? DateTime.now(),
       _viewType = viewType;

  DateTime get currentDate => _currentDate;
  CalendarViewType get viewType => _viewType;

  int get currentYear => _currentDate.year;
  int get currentMonth => _currentDate.month;

  /// Sets the current date to [date] and notifies listeners.
  void setDate(DateTime date) {
    _currentDate = date;
    notifyListeners();
  }

  /// Switches the calendar view type (month, week, day, etc.).
  void setViewType(CalendarViewType type) {
    _viewType = type;
    notifyListeners();
  }

  /// Navigates to today's date.
  void goToToday() {
    _currentDate = DateTime.now();
    notifyListeners();
  }

  /// Advances to the next month.
  void nextMonth() {
    _currentDate = GregorianCalendar.addMonths(_currentDate, 1);
    notifyListeners();
  }

  /// Goes back to the previous month.
  void previousMonth() {
    _currentDate = GregorianCalendar.addMonths(_currentDate, -1);
    notifyListeners();
  }

  /// Advances to the next year.
  void nextYear() {
    _currentDate = DateTime(_currentDate.year + 1, _currentDate.month, 1);
    notifyListeners();
  }

  /// Goes back to the previous year.
  void previousYear() {
    _currentDate = DateTime(_currentDate.year - 1, _currentDate.month, 1);
    notifyListeners();
  }

  /// Advances to the next week.
  void nextWeek() {
    _currentDate = _currentDate.add(const Duration(days: 7));
    notifyListeners();
  }

  /// Goes back to the previous week.
  void previousWeek() {
    _currentDate = _currentDate.subtract(const Duration(days: 7));
    notifyListeners();
  }

  /// Advances to the next day.
  void nextDay() {
    _currentDate = _currentDate.add(const Duration(days: 1));
    notifyListeners();
  }

  /// Goes back to the previous day.
  void previousDay() {
    _currentDate = _currentDate.subtract(const Duration(days: 1));
    notifyListeners();
  }
}
