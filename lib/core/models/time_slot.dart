/// 时间段
class TimeSlot {
  final DateTime start;
  final DateTime end;
  final bool isAvailable;

  const TimeSlot({
    required this.start,
    required this.end,
    this.isAvailable = true,
  });

  Duration get duration => end.difference(start);

  bool overlaps(TimeSlot other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }
}
