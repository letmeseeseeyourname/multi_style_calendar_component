import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// 里程碑数据
class Milestone {
  final String title;
  final DateTime targetDate;
  final IconData icon;
  final Color color;
  final String? description;

  const Milestone({
    required this.title,
    required this.targetDate,
    required this.icon,
    required this.color,
    this.description,
  });

  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    return target.difference(today).inDays;
  }

  bool get isPast => daysRemaining < 0;
  bool get isToday => daysRemaining == 0;
  double get progress {
    // Assume milestone was set 30 days ago for demo
    final totalDays = 30;
    final elapsed = totalDays - daysRemaining;
    return (elapsed / totalDays).clamp(0.0, 1.0);
  }
}

/// 里程碑追踪组件
class MilestoneTracker extends StatelessWidget {
  final List<Milestone> milestones;
  final ValueChanged<Milestone>? onMilestoneTap;

  const MilestoneTracker({
    super.key,
    required this.milestones,
    this.onMilestoneTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sorted = List<Milestone>.from(milestones)
      ..sort((a, b) => a.targetDate.compareTo(b.targetDate));

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
              const Icon(Icons.flag, color: Color(0xFFFF5722), size: 20),
              const SizedBox(width: 8),
              Text(
                l.milestone,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sorted.map(
            (milestone) => _MilestoneCard(
              milestone: milestone,
              l: l,
              onTap: () => onMilestoneTap?.call(milestone),
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final Milestone milestone;
  final AppLocalizations l;
  final VoidCallback? onTap;

  const _MilestoneCard({required this.milestone, required this.l, this.onTap});

  @override
  Widget build(BuildContext context) {
    final days = milestone.daysRemaining;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: milestone.color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: milestone.color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: milestone.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(milestone.icon, color: milestone.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.monthDay(
                      milestone.targetDate.month,
                      milestone.targetDate.day,
                    ),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (milestone.description != null)
                    Text(
                      milestone.description!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: milestone.progress,
                      minHeight: 4,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        milestone.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  milestone.isPast
                      ? l.passed
                      : milestone.isToday
                      ? l.today
                      : '$days',
                  style: TextStyle(
                    fontSize: milestone.isPast || milestone.isToday ? 14 : 22,
                    fontWeight: FontWeight.bold,
                    color: milestone.isPast
                        ? Colors.grey
                        : milestone.isToday
                        ? const Color(0xFF4CAF50)
                        : milestone.color,
                  ),
                ),
                if (!milestone.isPast && !milestone.isToday)
                  Text(
                    l.daySuffixUnit,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 生成模拟里程碑数据
List<Milestone> generateMockMilestones(AppLocalizations l) {
  final now = DateTime.now();
  return [
    Milestone(
      title: l.projectDelivery,
      targetDate: now.add(const Duration(days: 15)),
      icon: Icons.rocket_launch,
      color: const Color(0xFF2196F3),
      description: l.v1Release,
    ),
    Milestone(
      title: l.yearEndReview,
      targetDate: now.add(const Duration(days: 45)),
      icon: Icons.assessment,
      color: const Color(0xFFFF9800),
      description: l.prepareReport,
    ),
    Milestone(
      title: l.vacationStart,
      targetDate: now.add(const Duration(days: 60)),
      icon: Icons.flight,
      color: const Color(0xFF4CAF50),
      description: l.tokyoTrip,
    ),
    Milestone(
      title: l.birthday,
      targetDate: now.add(const Duration(days: 90)),
      icon: Icons.cake,
      color: const Color(0xFFE91E63),
    ),
    Milestone(
      title: l.pastEvent,
      targetDate: now.subtract(const Duration(days: 5)),
      icon: Icons.check_circle,
      color: const Color(0xFF9E9E9E),
      description: l.completed,
    ),
  ];
}
