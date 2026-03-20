import 'package:flutter/material.dart';
import '../models/calendar_config.dart';
import '../calendar_system/gregorian_calendar.dart';

/// 核心日历控制器
class CalendarController extends ChangeNotifier {
  DateTime _currentDate;
  CalendarViewType _viewType;

  CalendarController({
    DateTime? initialDate,
    CalendarViewType viewType = CalendarViewType.month,
  })  : _currentDate = initialDate ?? DateTime.now(),
        _viewType = viewType;

  DateTime get currentDate => _currentDate;
  CalendarViewType get viewType => _viewType;

  int get currentYear => _currentDate.year;
  int get currentMonth => _currentDate.month;

  void setDate(DateTime date) {
    _currentDate = date;
    notifyListeners();
  }

  void setViewType(CalendarViewType type) {
    _viewType = type;
    notifyListeners();
  }

  void goToToday() {
    _currentDate = DateTime.now();
    notifyListeners();
  }

  void nextMonth() {
    _currentDate = GregorianCalendar.addMonths(_currentDate, 1);
    notifyListeners();
  }

  void previousMonth() {
    _currentDate = GregorianCalendar.addMonths(_currentDate, -1);
    notifyListeners();
  }

  void nextYear() {
    _currentDate = DateTime(_currentDate.year + 1, _currentDate.month, 1);
    notifyListeners();
  }

  void previousYear() {
    _currentDate = DateTime(_currentDate.year - 1, _currentDate.month, 1);
    notifyListeners();
  }

  void nextWeek() {
    _currentDate = _currentDate.add(const Duration(days: 7));
    notifyListeners();
  }

  void previousWeek() {
    _currentDate = _currentDate.subtract(const Duration(days: 7));
    notifyListeners();
  }

  void nextDay() {
    _currentDate = _currentDate.add(const Duration(days: 1));
    notifyListeners();
  }

  void previousDay() {
    _currentDate = _currentDate.subtract(const Duration(days: 1));
    notifyListeners();
  }
}
