import '../models/calendar_date.dart';
import 'lunar_calendar.dart';
import 'islamic_calendar.dart';

/// 历法转换器
class CalendarConverter {
  CalendarConverter._();

  static CalendarDate fromGregorian(DateTime date) {
    final base = CalendarDate.fromDateTime(date);
    return base;
  }

  static LunarDate toLunar(DateTime date) {
    return LunarCalendarSystem.fromGregorian(date);
  }

  static IslamicDate toIslamic(DateTime date) {
    return IslamicCalendarSystem.fromGregorian(date);
  }

  static DateTime lunarToGregorian(int year, int month, int day) {
    return LunarCalendarSystem.toGregorian(year, month, day);
  }
}
