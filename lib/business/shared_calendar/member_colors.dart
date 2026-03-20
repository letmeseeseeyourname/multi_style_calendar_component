import 'package:flutter/material.dart';

/// 成员颜色分配
class MemberColors {
  MemberColors._();

  static const List<Color> _palette = [
    Color(0xFF2196F3), // blue
    Color(0xFF4CAF50), // green
    Color(0xFFFF9800), // orange
    Color(0xFF9C27B0), // purple
    Color(0xFFE91E63), // pink
    Color(0xFF00BCD4), // cyan
    Color(0xFF795548), // brown
    Color(0xFFFF5722), // deep orange
    Color(0xFF3F51B5), // indigo
    Color(0xFF009688), // teal
  ];

  /// 根据索引获取颜色
  static Color getColor(int index) {
    return _palette[index % _palette.length];
  }

  /// 根据成员名字生成一致的颜色
  static Color getColorForName(String name) {
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return _palette[hash.abs() % _palette.length];
  }

  /// 创建成员列表
  static List<CalendarMember> createMembers(List<String> names) {
    return List.generate(names.length, (i) {
      return CalendarMember(
        id: 'member_$i',
        name: names[i],
        color: getColor(i),
      );
    });
  }
}

/// 共享日历成员
class CalendarMember {
  final String id;
  final String name;
  final Color color;
  final String? avatar;

  const CalendarMember({
    required this.id,
    required this.name,
    required this.color,
    this.avatar,
  });
}

/// 共享事件
class SharedEvent {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String creatorId;
  final List<String> attendeeIds;
  final String? location;

  const SharedEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.creatorId,
    this.attendeeIds = const [],
    this.location,
  });

  bool occursOn(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(startTime.year, startTime.month, startTime.day);
    final endOnly = DateTime(endTime.year, endTime.month, endTime.day);
    return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
  }

  /// Get all member IDs involved
  List<String> get allMemberIds => [creatorId, ...attendeeIds];

  String get timeText {
    final sh = startTime.hour.toString().padLeft(2, '0');
    final sm = startTime.minute.toString().padLeft(2, '0');
    final eh = endTime.hour.toString().padLeft(2, '0');
    final em = endTime.minute.toString().padLeft(2, '0');
    return '$sh:$sm - $eh:$em';
  }
}

/// 生成模拟成员数据
List<CalendarMember> generateMockMembers() {
  return MemberColors.createMembers(['张三', '李四', '王五', '赵六']);
}

/// 生成模拟共享事件数据
List<SharedEvent> generateMockSharedEvents() {
  final now = DateTime.now();
  return [
    SharedEvent(
      id: 'se1',
      title: '团队周会',
      startTime: DateTime(now.year, now.month, now.day, 10, 0),
      endTime: DateTime(now.year, now.month, now.day, 11, 0),
      creatorId: 'member_0',
      attendeeIds: ['member_1', 'member_2', 'member_3'],
      location: '会议室A',
    ),
    SharedEvent(
      id: 'se2',
      title: '项目评审',
      startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
      endTime: DateTime(now.year, now.month, now.day + 1, 16, 0),
      creatorId: 'member_1',
      attendeeIds: ['member_0', 'member_2'],
      location: '会议室B',
    ),
    SharedEvent(
      id: 'se3',
      title: '产品需求讨论',
      startTime: DateTime(now.year, now.month, now.day + 2, 9, 0),
      endTime: DateTime(now.year, now.month, now.day + 2, 10, 30),
      creatorId: 'member_2',
      attendeeIds: ['member_0'],
    ),
    SharedEvent(
      id: 'se4',
      title: '1对1沟通',
      startTime: DateTime(now.year, now.month, now.day + 1, 10, 0),
      endTime: DateTime(now.year, now.month, now.day + 1, 11, 0),
      creatorId: 'member_0',
      attendeeIds: ['member_3'],
    ),
    SharedEvent(
      id: 'se5',
      title: '代码评审',
      startTime: DateTime(now.year, now.month, now.day + 3, 15, 0),
      endTime: DateTime(now.year, now.month, now.day + 3, 16, 0),
      creatorId: 'member_3',
      attendeeIds: ['member_0', 'member_1'],
    ),
    SharedEvent(
      id: 'se6',
      title: '团建活动',
      startTime: DateTime(now.year, now.month, now.day + 5, 13, 0),
      endTime: DateTime(now.year, now.month, now.day + 5, 18, 0),
      creatorId: 'member_0',
      attendeeIds: ['member_1', 'member_2', 'member_3'],
      location: '户外拓展基地',
    ),
    SharedEvent(
      id: 'se7',
      title: '技术分享',
      startTime: DateTime(now.year, now.month, now.day - 1, 14, 0),
      endTime: DateTime(now.year, now.month, now.day - 1, 15, 0),
      creatorId: 'member_1',
      attendeeIds: ['member_0', 'member_2', 'member_3'],
    ),
  ];
}
