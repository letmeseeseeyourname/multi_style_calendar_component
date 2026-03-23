import 'package:lunar/lunar.dart';

/// A universal calendar date that supports multiple calendar systems.
///
/// Wraps a Gregorian [DateTime] and optionally includes lunar and Islamic
/// calendar representations, along with metadata such as solar terms,
/// festivals, and holiday information.
class CalendarDate {
  /// The Gregorian (standard) date.
  final DateTime gregorian;

  /// The Chinese lunar calendar date, if available.
  final LunarDate? lunar;

  /// The Islamic (Hijri) calendar date, if available.
  final IslamicDate? islamic;

  /// Whether this date is today.
  final bool isToday;

  /// Whether this date falls on a weekend (Saturday or Sunday).
  final bool isWeekend;

  /// Whether this date is a public holiday.
  final bool isHoliday;

  /// The name of the holiday, if applicable.
  final String? holidayName;

  /// The solar term name (e.g. "Spring Equinox"), if this date falls on one.
  final String? solarTerm;

  /// The Chinese lunar festival name, if applicable.
  final String? lunarFestival;

  /// The Chinese zodiac animal for this year.
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

  /// Creates a [CalendarDate] from a [DateTime], automatically computing
  /// lunar calendar data, solar terms, and festival information.
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

  /// Returns a copy with updated holiday information.
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

/// Represents a date in the Chinese lunar calendar.
///
/// Includes the Heavenly Stems and Earthly Branches (GanZhi) cycle,
/// zodiac animal, and Chinese character representations.
class LunarDate {
  /// The lunar year number.
  final int year;

  /// The lunar month (negative value indicates a leap month).
  final int month;

  /// The lunar day of the month.
  final int day;

  /// Whether this month is a leap month in the lunar calendar.
  final bool isLeapMonth;

  /// The year expressed in the GanZhi (Heavenly Stems & Earthly Branches) cycle.
  final String yearGanZhi;

  /// The month expressed in the GanZhi cycle.
  final String monthGanZhi;

  /// The day expressed in the GanZhi cycle.
  final String dayGanZhi;

  /// The Chinese zodiac animal for this year.
  final String zodiac;

  /// The year in Chinese characters.
  final String yearChinese;

  /// The month in Chinese characters (e.g. "正月").
  final String monthChinese;

  /// The day in Chinese characters (e.g. "初一").
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

  /// The full Chinese representation combining month and day (e.g. "正月初一").
  String get fullChinese => '$monthChinese$dayChinese';
}

/// Represents a date in the Islamic (Hijri) calendar.
///
/// This is a placeholder implementation for future expansion.
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
