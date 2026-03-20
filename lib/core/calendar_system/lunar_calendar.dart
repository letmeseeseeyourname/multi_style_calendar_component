import 'package:lunar/lunar.dart' as lunar_pkg;
import '../models/calendar_date.dart';

/// 农历日历系统
class LunarCalendarSystem {
  LunarCalendarSystem._();

  static LunarDate fromGregorian(DateTime date) {
    final solar = lunar_pkg.Solar.fromDate(date);
    final lunar = solar.getLunar();

    return LunarDate(
      year: lunar.getYear(),
      month: lunar.getMonth(),
      day: lunar.getDay(),
      isLeapMonth: lunar.getMonth() < 0,
      yearGanZhi: lunar.getYearInGanZhi(),
      monthGanZhi: lunar.getMonthInGanZhi(),
      dayGanZhi: lunar.getDayInGanZhi(),
      zodiac: lunar.getYearShengXiao(),
      yearChinese: lunar.getYearInChinese(),
      monthChinese: lunar.getMonthInChinese(),
      dayChinese: lunar.getDayInChinese(),
    );
  }

  static DateTime toGregorian(int year, int month, int day) {
    final lunar = lunar_pkg.Lunar.fromYmd(year, month, day);
    final solar = lunar.getSolar();
    return DateTime(solar.getYear(), solar.getMonth(), solar.getDay());
  }
}
