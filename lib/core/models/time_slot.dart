/// A time slot with a start and end time, typically used for booking or scheduling.
class TimeSlot {
  /// The start time of the slot.
  final DateTime start;

  /// The end time of the slot.
  final DateTime end;

  /// Whether this time slot is available for booking.
  final bool isAvailable;

  const TimeSlot({
    required this.start,
    required this.end,
    this.isAvailable = true,
  });

  /// The duration of this time slot.
  Duration get duration => end.difference(start);

  /// Returns `true` if this time slot overlaps with [other].
  bool overlaps(TimeSlot other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }
}
