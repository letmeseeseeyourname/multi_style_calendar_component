import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/controllers/event_controller.dart';
import '../core/models/calendar_event.dart';

final eventControllerProvider = ChangeNotifierProvider<EventController>((ref) {
  final controller = EventController();
  // 添加示例事件
  controller.addAll(_sampleEvents());
  return controller;
});

List<CalendarEvent> _sampleEvents() {
  final now = DateTime.now();
  return [
    CalendarEvent(
      id: '1',
      title: '团队周会',
      description: '每周一次的团队例会',
      startTime: DateTime(now.year, now.month, now.day, 10, 0),
      endTime: DateTime(now.year, now.month, now.day, 11, 0),
      color: Colors.blue,
    ),
    CalendarEvent(
      id: '2',
      title: '午餐约会',
      startTime: DateTime(now.year, now.month, now.day, 12, 0),
      endTime: DateTime(now.year, now.month, now.day, 13, 0),
      color: Colors.green,
    ),
    CalendarEvent(
      id: '3',
      title: '项目截止日',
      startTime: DateTime(now.year, now.month, now.day + 3, 0, 0),
      endTime: DateTime(now.year, now.month, now.day + 3, 23, 59),
      isAllDay: true,
      color: Colors.red,
    ),
    CalendarEvent(
      id: '4',
      title: '出差',
      startTime: DateTime(now.year, now.month, now.day + 5, 8, 0),
      endTime: DateTime(now.year, now.month, now.day + 7, 18, 0),
      isAllDay: true,
      color: Colors.orange,
    ),
    CalendarEvent(
      id: '5',
      title: '下午茶',
      startTime: DateTime(now.year, now.month, now.day, 15, 0),
      endTime: DateTime(now.year, now.month, now.day, 15, 30),
      color: Colors.purple,
    ),
  ];
}
