/// 日期范围
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange(this.start, this.end);

  bool contains(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);
    return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
  }

  int get dayCount => end.difference(start).inDays + 1;

  List<DateTime> get days {
    final list = <DateTime>[];
    var current = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);
    while (!current.isAfter(endOnly)) {
      list.add(current);
      current = current.add(const Duration(days: 1));
    }
    return list;
  }
}
