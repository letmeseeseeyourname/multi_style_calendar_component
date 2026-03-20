import '../../../l10n/app_localizations.dart';
import 'member_colors.dart';

/// 时间冲突信息
class ConflictInfo {
  final SharedEvent eventA;
  final SharedEvent eventB;
  final List<String> conflictingMemberIds;

  const ConflictInfo({
    required this.eventA,
    required this.eventB,
    required this.conflictingMemberIds,
  });

  Duration get overlapDuration {
    final overlapStart = eventA.startTime.isAfter(eventB.startTime)
        ? eventA.startTime
        : eventB.startTime;
    final overlapEnd = eventA.endTime.isBefore(eventB.endTime)
        ? eventA.endTime
        : eventB.endTime;
    return overlapEnd.difference(overlapStart);
  }

  String get overlapText {
    final minutes = overlapDuration.inMinutes;
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remaining = minutes % 60;
      return remaining > 0 ? '$hours小时${remaining}分钟' : '$hours小时';
    }
    return '$minutes分钟';
  }

  String localizedOverlapText(AppLocalizations l) {
    return l.durationText(overlapDuration.inMinutes);
  }
}

/// 时间冲突检测
class ConflictDetector {
  ConflictDetector._();

  /// 检测两个事件是否时间重叠
  static bool _eventsOverlap(SharedEvent a, SharedEvent b) {
    return a.startTime.isBefore(b.endTime) && a.endTime.isAfter(b.startTime);
  }

  /// 查找事件列表中所有时间冲突
  static List<ConflictInfo> findConflicts(List<SharedEvent> events) {
    final sorted = List<SharedEvent>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final conflicts = <ConflictInfo>[];

    for (int i = 0; i < sorted.length; i++) {
      for (int j = i + 1; j < sorted.length; j++) {
        if (_eventsOverlap(sorted[i], sorted[j])) {
          // Find common members
          final membersA = sorted[i].allMemberIds.toSet();
          final membersB = sorted[j].allMemberIds.toSet();
          final commonMembers = membersA.intersection(membersB).toList();

          if (commonMembers.isNotEmpty) {
            conflicts.add(ConflictInfo(
              eventA: sorted[i],
              eventB: sorted[j],
              conflictingMemberIds: commonMembers,
            ));
          }
        } else {
          // Events are sorted, no need to check further
          break;
        }
      }
    }

    return conflicts;
  }

  /// 检测某个事件是否与其他事件冲突
  static bool hasConflict(SharedEvent event, List<SharedEvent> others) {
    return others.any((other) =>
        other.id != event.id && _eventsOverlap(event, other));
  }

  /// 获取某个成员在指定日期的所有冲突
  static List<ConflictInfo> findConflictsForMember(
    String memberId,
    List<SharedEvent> events,
    DateTime date,
  ) {
    final memberEvents = events
        .where((e) =>
            e.allMemberIds.contains(memberId) && e.occursOn(date))
        .toList();
    return findConflicts(memberEvents);
  }

  /// 获取指定日期的所有冲突
  static List<ConflictInfo> findConflictsOnDate(
    List<SharedEvent> events,
    DateTime date,
  ) {
    final dayEvents = events.where((e) => e.occursOn(date)).toList();
    return findConflicts(dayEvents);
  }
}
