/// Utility methods for date calculations used throughout the calendar.
///
/// All methods are static. This class cannot be instantiated.
class CalendarDateUtils {
  CalendarDateUtils._();

  /// Strips the time component, returning midnight on the same date.
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns `true` if [a] and [b] fall on the same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Returns `true` if [a] and [b] are in the same year and month.
  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  /// Returns the number of days in the given [month] of [year].
  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Returns the first day of the month containing [date].
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Returns the last day of the month containing [date].
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Returns the first day of the week containing [date].
  ///
  /// [firstDay] specifies which day starts the week (1 = Monday, 7 = Sunday).
  static DateTime firstDayOfWeek(DateTime date, {int firstDay = 1}) {
    final diff = (date.weekday - firstDay + 7) % 7;
    return dateOnly(date.subtract(Duration(days: diff)));
  }

  /// Returns 42 dates (6 weeks) for a month grid view, including leading
  /// and trailing days from adjacent months to fill the grid.
  static List<DateTime> daysInMonthGrid(
    DateTime month, {
    int firstDayOfWeek = 1,
  }) {
    final first = firstDayOfMonth(month);
    final startOffset = (first.weekday - firstDayOfWeek + 7) % 7;
    final gridStart = first.subtract(Duration(days: startOffset));

    final days = <DateTime>[];
    for (int i = 0; i < 42; i++) {
      days.add(gridStart.add(Duration(days: i)));
    }
    return days;
  }

  /// Returns the ISO week number for the given [date].
  static int weekNumber(DateTime date) {
    final firstJan = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstJan).inDays;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  /// Returns the 7 dates of the week containing [date].
  static List<DateTime> daysInWeek(DateTime date, {int startOfWeek = 1}) {
    final start = firstDayOfWeek(date, firstDay: startOfWeek);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  /// Returns the Chinese name for the given [month] (1-12).
  static String monthName(int month) {
    const names = [
      '',
      '一月',
      '二月',
      '三月',
      '四月',
      '五月',
      '六月',
      '七月',
      '八月',
      '九月',
      '十月',
      '十一月',
      '十二月',
    ];
    return names[month];
  }

  /// Returns the Chinese weekday name for [weekday] (1 = Monday, 7 = Sunday).
  ///
  /// If [short] is `true`, returns a single character; otherwise a two-character label.
  static String weekdayName(int weekday, {bool short = true}) {
    const shortNames = ['一', '二', '三', '四', '五', '六', '日'];
    const longNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final index = (weekday - 1) % 7;
    return short ? shortNames[index] : longNames[index];
  }
}
