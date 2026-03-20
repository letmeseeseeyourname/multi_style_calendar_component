import '../utils/date_utils.dart';

/// 公历日历系统
class GregorianCalendar {
  GregorianCalendar._();

  static int daysInMonth(int year, int month) {
    return CalendarDateUtils.daysInMonth(year, month);
  }

  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  static int daysInYear(int year) {
    return isLeapYear(year) ? 366 : 365;
  }

  static DateTime addMonths(DateTime date, int months) {
    final newMonth = date.month + months;
    final newYear = date.year + (newMonth - 1) ~/ 12;
    final normalizedMonth = ((newMonth - 1) % 12) + 1;
    final maxDay = daysInMonth(newYear, normalizedMonth);
    return DateTime(newYear, normalizedMonth, date.day.clamp(1, maxDay));
  }
}
