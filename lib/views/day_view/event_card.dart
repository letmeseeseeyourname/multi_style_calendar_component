import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';

/// A card representing a single [CalendarEvent] positioned on the day
/// timeline.
///
/// The parent is responsible for wrapping this widget in a [Positioned] with
/// the correct `top` and `height` values derived from the event's start/end
/// times.
class EventCard extends StatelessWidget {
  /// The event to render.
  final CalendarEvent event;

  /// Called when the user taps on this card.
  final VoidCallback? onTap;

  /// Called when the user long-presses (useful for drag initiation).
  final VoidCallback? onLongPress;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        ThemeData.estimateBrightnessForColor(event.color) == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final borderColor = event.color;
    final bgColor = event.color.withValues(alpha: 0.85);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border(
            left: BorderSide(color: borderColor, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: event.color.withValues(alpha: 0.25),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 1),
            // Time range
            Text(
              _formatTimeRange(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 10,
                height: 1.2,
              ),
            ),
            // Location (if space allows and present)
            if (event.location != null && event.location!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 10,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        event.location!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.7),
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimeRange() {
    String fmt(DateTime t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return '${fmt(event.startTime)} - ${fmt(event.endTime)}';
  }
}
