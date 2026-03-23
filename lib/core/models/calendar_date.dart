import 'package:lunar/lunar.dart';

/// 通用日历日期，支持多历法
class CalendarDate {
  final DateTime gregorian;
  final LunarDate? lunar;
  final IslamicDate? islamic;

  final bool isToday;
  final bool isWeekend;
  final bool isHoliday;
  final String? holidayName;

  final String? solarTerm;
  final String? lunarFestival;
  final String? zodiac;

  CalendarDate({
    required this.gregorian,
    this.lunar,
    this.islamic,
    this.isToday = false,
    this.isWeekend = false,
    this.isHoliday = false,
    this.holidayName,
    this.solarTerm,
    this.lunarFestival,
    this.zodiac,
  });

  factory CalendarDate.fromDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final weekday = date.weekday;

    final solar = Solar.fromDate(date);
    final lunarObj = solar.getLunar();

    String? solarTerm;
    final jieQi = lunarObj.getCurrentJieQi();
    if (jieQi != null) {
      solarTerm = jieQi.getName();
    }

    String? lunarFestival;
    final festivals = lunarObj.getFestivals();
    if (festivals.isNotEmpty) {
      lunarFestival = festivals.first;
    }

    final lunarDate = LunarDate(
      year: lunarObj.getYear(),
      month: lunarObj.getMonth(),
      day: lunarObj.getDay(),
      isLeapMonth: lunarObj.getMonth() < 0,
      yearGanZhi: lunarObj.getYearInGanZhi(),
      monthGanZhi: lunarObj.getMonthInGanZhi(),
      dayGanZhi: lunarObj.getDayInGanZhi(),
      zodiac: lunarObj.getYearShengXiao(),
      yearChinese: lunarObj.getYearInChinese(),
      monthChinese: lunarObj.getMonthInChinese(),
      dayChinese: lunarObj.getDayInChinese(),
    );

    return CalendarDate(
      gregorian: date,
      lunar: lunarDate,
      isToday: dateOnly == today,
      isWeekend: weekday == DateTime.saturday || weekday == DateTime.sunday,
      solarTerm: solarTerm,
      lunarFestival: lunarFestival,
      zodiac: lunarObj.getYearShengXiao(),
    );
  }

  CalendarDate copyWith({bool? isHoliday, String? holidayName}) {
    return CalendarDate(
      gregorian: gregorian,
      lunar: lunar,
      islamic: islamic,
      isToday: isToday,
      isWeekend: isWeekend,
      isHoliday: isHoliday ?? this.isHoliday,
      holidayName: holidayName ?? this.holidayName,
      solarTerm: solarTerm,
      lunarFestival: lunarFestival,
      zodiac: zodiac,
    );
  }
}

/// 农历日期
class LunarDate {
  final int year;
  final int month;
  final int day;
  final bool isLeapMonth;

  final String yearGanZhi;
  final String monthGanZhi;
  final String dayGanZhi;

  final String zodiac;
  final String yearChinese;
  final String monthChinese;
  final String dayChinese;

  const LunarDate({
    required this.year,
    required this.month,
    required this.day,
    required this.isLeapMonth,
    required this.yearGanZhi,
    required this.monthGanZhi,
    required this.dayGanZhi,
    required this.zodiac,
    required this.yearChinese,
    required this.monthChinese,
    required this.dayChinese,
  });

  String get fullChinese => '$monthChinese$dayChinese';
}

/// 伊斯兰历日期（占位）
class IslamicDate {
  final int year;
  final int month;
  final int day;

  const IslamicDate({
    required this.year,
    required this.month,
    required this.day,
  });
}
