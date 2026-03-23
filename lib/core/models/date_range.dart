/// An inclusive date range defined by a [start] and [end] date.
class DateRange {
  /// The first date in the range.
  final DateTime start;

  /// The last date in the range (inclusive).
  final DateTime end;

  const DateRange(this.start, this.end);

  /// Returns `true` if [date] falls within this range (inclusive of both ends).
  bool contains(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);
    return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
  }

  /// The total number of days in this range (inclusive).
  int get dayCount => end.difference(start).inDays + 1;

  /// Returns a list of all dates in this range, one per day.
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
