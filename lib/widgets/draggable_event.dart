import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/models/calendar_event.dart';

/// A long-press-draggable event card with shadow effect and haptic feedback.
class DraggableEvent extends StatefulWidget {
  final CalendarEvent event;

  /// Called when the drag ends, providing the global position.
  final ValueChanged<Offset>? onDragEnd;

  /// Called when the drag starts.
  final VoidCallback? onDragStart;

  /// Called when the event is tapped.
  final VoidCallback? onTap;

  /// Height of the event card.
  final double? height;

  const DraggableEvent({
    super.key,
    required this.event,
    this.onDragEnd,
    this.onDragStart,
    this.onTap,
    this.height,
  });

  @override
  State<DraggableEvent> createState() => _DraggableEventState();
}

class _DraggableEventState extends State<DraggableEvent>
    with SingleTickerProviderStateMixin {
  bool _isDragging = false;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Widget _buildCard({bool isFeedback = false}) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.event.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isDragging || isFeedback
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          if (widget.height == null || (widget.height ?? 0) > 30)
            Text(
              widget.event.isAllDay
                  ? '全天'
                  : '${_formatTime(widget.event.startTime)} - ${_formatTime(widget.event.endTime)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white70,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<CalendarEvent>(
      data: widget.event,
      delay: const Duration(milliseconds: 300),
      hapticFeedbackOnStart: true,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Opacity(
            opacity: 0.9,
            child: _buildCard(isFeedback: true),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCard(),
      ),
      onDragStarted: () {
        setState(() => _isDragging = true);
        _scaleController.forward();
        HapticFeedback.mediumImpact();
        widget.onDragStart?.call();
      },
      onDragEnd: (details) {
        setState(() => _isDragging = false);
        _scaleController.reverse();
        widget.onDragEnd?.call(details.offset);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _buildCard(),
        ),
      ),
    );
  }
}
