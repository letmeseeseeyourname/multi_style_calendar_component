import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'attendance_status.dart';

/// 月度考勤统计组件
class AttendanceStats extends StatelessWidget {
  final Map<String, AttendanceRecord> records;
  final DateTime month;

  const AttendanceStats({
    super.key,
    required this.records,
    required this.month,
  });

  Map<AttendanceStatus, int> get _statusCounts {
    final counts = <AttendanceStatus, int>{};
    for (final record in records.values) {
      if (record.date.year == month.year && record.date.month == month.month) {
        counts[record.status] = (counts[record.status] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final counts = _statusCounts;
    final normalDays = counts[AttendanceStatus.normal] ?? 0;
    final lateDays = counts[AttendanceStatus.late] ?? 0;
    final leaveEarlyDays = counts[AttendanceStatus.leaveEarly] ?? 0;
    final absentDays = counts[AttendanceStatus.absent] ?? 0;
    final leaveDays = counts[AttendanceStatus.leave] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, size: 20, color: Color(0xFF2196F3)),
              const SizedBox(width: 8),
              Text(
                l.attendanceStatsTitle(month.month),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(
                label: l.attendanceDays,
                value: normalDays,
                color: AttendanceStatus.normal.color,
              ),
              _StatItem(
                label: l.late_,
                value: lateDays,
                color: AttendanceStatus.late.color,
              ),
              _StatItem(
                label: l.leaveEarly,
                value: leaveEarlyDays,
                color: AttendanceStatus.leaveEarly.color,
              ),
              _StatItem(
                label: l.absent,
                value: absentDays,
                color: AttendanceStatus.absent.color,
              ),
              _StatItem(
                label: l.onLeave,
                value: leaveDays,
                color: AttendanceStatus.leave.color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Attendance rate bar
          _AttendanceRateBar(
            normalDays: normalDays,
            totalWorkDays: normalDays + lateDays + leaveEarlyDays + absentDays + leaveDays,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _AttendanceRateBar extends StatelessWidget {
  final int normalDays;
  final int totalWorkDays;

  const _AttendanceRateBar({
    required this.normalDays,
    required this.totalWorkDays,
  });

  @override
  Widget build(BuildContext context) {
    final rate = totalWorkDays > 0 ? normalDays / totalWorkDays : 0.0;
    final percentage = (rate * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).attendanceRate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: rate >= 0.9
                    ? const Color(0xFF4CAF50)
                    : rate >= 0.7
                        ? const Color(0xFFFF9800)
                        : const Color(0xFFF44336),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: rate,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              rate >= 0.9
                  ? const Color(0xFF4CAF50)
                  : rate >= 0.7
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFF44336),
            ),
          ),
        ),
      ],
    );
  }
}
