import 'package:flutter/material.dart';

/// 拖拽控制器
class DragController extends ChangeNotifier {
  String? _draggingEventId;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  String? get draggingEventId => _draggingEventId;
  Offset get dragOffset => _dragOffset;
  bool get isDragging => _isDragging;

  void startDrag(String eventId) {
    _draggingEventId = eventId;
    _isDragging = true;
    _dragOffset = Offset.zero;
    notifyListeners();
  }

  void updateDrag(Offset delta) {
    _dragOffset += delta;
    notifyListeners();
  }

  void endDrag() {
    _draggingEventId = null;
    _isDragging = false;
    _dragOffset = Offset.zero;
    notifyListeners();
  }

  DateTime calculateNewTime(
    DateTime originalTime,
    double hourHeight,
    double dayWidth,
  ) {
    final hourDelta = _dragOffset.dy / hourHeight;
    final dayDelta = (_dragOffset.dx / dayWidth).round();

    return originalTime
        .add(Duration(days: dayDelta))
        .add(Duration(minutes: (hourDelta * 60).round()));
  }
}
