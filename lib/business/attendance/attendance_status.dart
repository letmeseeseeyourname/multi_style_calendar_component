import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// 考勤状态枚举
enum AttendanceStatus {
  normal, // 正常
  late, // 迟到
  leaveEarly, // 早退
  absent, // 缺勤
  leave, // 请假
  holiday, // 节假日
  rest, // 休息日
}

extension AttendanceStatusExtension on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.normal:
        return '正常';
      case AttendanceStatus.late:
        return '迟到';
      case AttendanceStatus.leaveEarly:
        return '早退';
      case AttendanceStatus.absent:
        return '缺勤';
      case AttendanceStatus.leave:
        return '请假';
      case AttendanceStatus.holiday:
        return '节假日';
      case AttendanceStatus.rest:
        return '休息日';
    }
  }

  String localizedLabel(AppLocalizations l) {
    switch (this) {
      case AttendanceStatus.normal:
        return l.normal;
      case AttendanceStatus.late:
        return l.late_;
      case AttendanceStatus.leaveEarly:
        return l.leaveEarly;
      case AttendanceStatus.absent:
        return l.absent;
      case AttendanceStatus.leave:
        return l.onLeave;
      case AttendanceStatus.holiday:
        return l.holiday;
      case AttendanceStatus.rest:
        return l.restDay;
    }
  }

  Color get color {
    switch (this) {
      case AttendanceStatus.normal:
        return const Color(0xFF4CAF50);
      case AttendanceStatus.late:
        return const Color(0xFFFF9800);
      case AttendanceStatus.leaveEarly:
        return const Color(0xFFFFC107);
      case AttendanceStatus.absent:
        return const Color(0xFFF44336);
      case AttendanceStatus.leave:
        return const Color(0xFF9C27B0);
      case AttendanceStatus.holiday:
        return const Color(0xFFE91E63);
      case AttendanceStatus.rest:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData get icon {
    switch (this) {
      case AttendanceStatus.normal:
        return Icons.check_circle;
      case AttendanceStatus.late:
        return Icons.schedule;
      case AttendanceStatus.leaveEarly:
        return Icons.exit_to_app;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.leave:
        return Icons.event_busy;
      case AttendanceStatus.holiday:
        return Icons.celebration;
      case AttendanceStatus.rest:
        return Icons.weekend;
    }
  }
}

/// 考勤记录
class AttendanceRecord {
  final DateTime date;
  final AttendanceStatus status;
  final TimeOfDay? checkInTime;
  final TimeOfDay? checkOutTime;
  final String? note;

  const AttendanceRecord({
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.note,
  });

  String get checkInText {
    if (checkInTime == null) return '--:--';
    return '${checkInTime!.hour.toString().padLeft(2, '0')}:${checkInTime!.minute.toString().padLeft(2, '0')}';
  }

  String get checkOutText {
    if (checkOutTime == null) return '--:--';
    return '${checkOutTime!.hour.toString().padLeft(2, '0')}:${checkOutTime!.minute.toString().padLeft(2, '0')}';
  }
}

/// 生成模拟考勤数据
Map<String, AttendanceRecord> generateMockAttendanceData(DateTime month) {
  final records = <String, AttendanceRecord>{};
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  final now = DateTime.now();

  for (int day = 1; day <= daysInMonth; day++) {
    final date = DateTime(month.year, month.month, day);
    if (date.isAfter(now)) continue;

    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final weekday = date.weekday;

    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      records[key] = AttendanceRecord(
        date: date,
        status: AttendanceStatus.rest,
      );
      continue;
    }

    // Create varied mock data
    final hash = (date.day * 7 + date.month * 13) % 20;
    if (hash == 0) {
      records[key] = AttendanceRecord(
        date: date,
        status: AttendanceStatus.absent,
        note: '未打卡',
      );
    } else if (hash == 1) {
      records[key] = AttendanceRecord(
        date: date,
        status: AttendanceStatus.late,
        checkInTime: const TimeOfDay(hour: 9, minute: 23),
        checkOutTime: const TimeOfDay(hour: 18, minute: 5),
      );
    } else if (hash == 2) {
      records[key] = AttendanceRecord(
        date: date,
        status: AttendanceStatus.leaveEarly,
        checkInTime: const TimeOfDay(hour: 8, minute: 55),
        checkOutTime: const TimeOfDay(hour: 16, minute: 30),
      );
    } else if (hash == 3) {
      records[key] = AttendanceRecord(
        date: date,
        status: AttendanceStatus.leave,
        note: '年假',
      );
    } else {
      records[key] = AttendanceRecord(
        date: date,
        status: AttendanceStatus.normal,
        checkInTime: TimeOfDay(hour: 8, minute: 30 + (hash % 25)),
        checkOutTime: TimeOfDay(hour: 18, minute: hash % 30),
      );
    }
  }
  return records;
}
