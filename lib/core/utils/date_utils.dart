/// 日期工具函数
class CalendarDateUtils {
  CalendarDateUtils._();

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static DateTime firstDayOfWeek(DateTime date, {int firstDay = 1}) {
    final diff = (date.weekday - firstDay + 7) % 7;
    return dateOnly(date.subtract(Duration(days: diff)));
  }

  static List<DateTime> daysInMonthGrid(DateTime month, {int firstDayOfWeek = 1}) {
    final first = firstDayOfMonth(month);
    final startOffset = (first.weekday - firstDayOfWeek + 7) % 7;
    final gridStart = first.subtract(Duration(days: startOffset));

    final days = <DateTime>[];
    for (int i = 0; i < 42; i++) {
      days.add(gridStart.add(Duration(days: i)));
    }
    return days;
  }

  static int weekNumber(DateTime date) {
    final firstJan = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstJan).inDays;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static List<DateTime> daysInWeek(DateTime date, {int startOfWeek = 1}) {
    final start = firstDayOfWeek(date, firstDay: startOfWeek);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  static String monthName(int month) {
    const names = [
      '', '一月', '二月', '三月', '四月', '五月', '六月',
      '七月', '八月', '九月', '十月', '十一月', '十二月',
    ];
    return names[month];
  }

  static String weekdayName(int weekday, {bool short = true}) {
    const shortNames = ['一', '二', '三', '四', '五', '六', '日'];
    const longNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final index = (weekday - 1) % 7;
    return short ? shortNames[index] : longNames[index];
  }
}
