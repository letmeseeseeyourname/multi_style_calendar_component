import '../models/calendar_date.dart';

/// 伊斯兰历日历系统（简化算法）
class IslamicCalendarSystem {
  IslamicCalendarSystem._();

  static const List<String> monthNames = [
    'Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Thani',
    'Jumada al-Ula', 'Jumada al-Thani', 'Rajab', 'Shaban',
    'Ramadan', 'Shawwal', 'Dhu al-Qadah', 'Dhu al-Hijjah',
  ];

  /// 简化的公历转伊斯兰历算法
  static IslamicDate fromGregorian(DateTime date) {
    final jd = _gregorianToJulian(date.year, date.month, date.day);
    return _julianToIslamic(jd);
  }

  static int _gregorianToJulian(int year, int month, int day) {
    final a = ((14 - month) / 12).floor();
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
  }

  static IslamicDate _julianToIslamic(int jd) {
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final remainder = l - 10631 * n + 354;
    final j = (((10985 - remainder) / 5316).floor()) *
            ((((50 * remainder) / 17719).floor())) +
        ((remainder / 5670).floor()) *
            ((((43 * remainder) / 15238).floor()));
    final correctedRemainder =
        remainder - (((30 - j) / 15).floor()) * (((17719 + j * 50) / 43).floor()) +
        (j / 16).floor() * (((15238 - j * 43) / 50).floor());
    final month = ((11 * correctedRemainder + 14) / 325).floor();
    final day = correctedRemainder - ((325 * month - 320) / 11).floor();
    final year = 30 * n + j + ((11 * month + 3) / 330).floor();

    return IslamicDate(
      year: year,
      month: month.clamp(1, 12),
      day: day.clamp(1, 30),
    );
  }
}
