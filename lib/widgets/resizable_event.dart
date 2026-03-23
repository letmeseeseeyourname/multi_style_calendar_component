import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/models/calendar_event.dart';

/// Event card with a bottom drag handle to resize its duration.
class ResizableEvent extends StatefulWidget {
  final CalendarEvent event;

  /// Height per minute in the parent time view.
  final double minuteHeight;

  /// Called when resizing completes, providing the new duration.
  final ValueChanged<Duration>? onResizeEnd;

  /// Called during resize, providing the current delta in pixels.
  final ValueChanged<double>? onResizeUpdate;

  /// Called when the event card is tapped.
  final VoidCallback? onTap;

  /// Minimum duration in minutes.
  final int minDurationMinutes;

  /// Maximum duration in minutes.
  final int maxDurationMinutes;

  const ResizableEvent({
    super.key,
    required this.event,
    this.minuteHeight = 1.0,
    this.onResizeEnd,
    this.onResizeUpdate,
    this.onTap,
    this.minDurationMinutes = 15,
    this.maxDurationMinutes = 480,
  });

  @override
  State<ResizableEvent> createState() => _ResizableEventState();
}

class _ResizableEventState extends State<ResizableEvent> {
  double _extraHeight = 0;
  bool _isResizing = false;

  double get _baseHeight =>
      widget.event.duration.inMinutes * widget.minuteHeight;

  double get _minHeight => widget.minDurationMinutes * widget.minuteHeight;

  double get _maxHeight => widget.maxDurationMinutes * widget.minuteHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentHeight = (_baseHeight + _extraHeight).clamp(
      _minHeight,
      _maxHeight,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: _isResizing
            ? Duration.zero
            : const Duration(milliseconds: 200),
        height: currentHeight,
        decoration: BoxDecoration(
          color: widget.event.color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: _isResizing
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: _isResizing ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Event content
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.event.title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTimeRange(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Bottom resize handle
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragStart: (_) {
                  setState(() => _isResizing = true);
                  HapticFeedback.selectionClick();
                },
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _extraHeight += details.delta.dy;
                    _extraHeight = _extraHeight.clamp(
                      _minHeight - _baseHeight,
                      _maxHeight - _baseHeight,
                    );
                  });
                  widget.onResizeUpdate?.call(_extraHeight);
                },
                onVerticalDragEnd: (_) {
                  final totalMinutes = (currentHeight / widget.minuteHeight)
                      .round();
                  final snappedMinutes =
                      (totalMinutes / 15).round() * 15; // snap to 15 min
                  final newDuration = Duration(minutes: snappedMinutes);

                  setState(() {
                    _isResizing = false;
                    _extraHeight =
                        snappedMinutes * widget.minuteHeight - _baseHeight;
                  });

                  widget.onResizeEnd?.call(newDuration);
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  height: 18,
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeRange() {
    final start = widget.event.startTime;
    final totalMinutes = ((_baseHeight + _extraHeight) / widget.minuteHeight)
        .round();
    final end = start.add(Duration(minutes: totalMinutes));

    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
