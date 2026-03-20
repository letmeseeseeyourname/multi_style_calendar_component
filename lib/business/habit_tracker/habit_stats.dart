import 'package:flutter/material.dart';
import 'streak_counter.dart';

/// 习惯统计组件
class HabitStats extends StatelessWidget {
  final StreakCounter streakCounter;
  final DateTime month;

  const HabitStats({
    super.key,
    required this.streakCounter,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final currentStreak = streakCounter.currentStreak;
    final longestStreak = streakCounter.longestStreak;
    final monthCompleted =
        streakCounter.completedInMonth(month.year, month.month);
    final monthTotal =
        streakCounter.totalDaysInMonth(month.year, month.month);
    final rate = streakCounter.completionRateInMonth(month.year, month.month);

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
        children: [
          Row(
            children: [
              _StatCard(
                icon: Icons.local_fire_department,
                iconColor: const Color(0xFFFF5722),
                label: '当前连续',
                value: '$currentStreak天',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.emoji_events,
                iconColor: const Color(0xFFFFB300),
                label: '最长连续',
                value: '$longestStreak天',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF4CAF50),
                label: '总打卡',
                value: '${streakCounter.totalCompleted}天',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Monthly completion bar
          Row(
            children: [
              Text(
                '${month.month}月完成率',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                '$monthCompleted/$monthTotal天 (${(rate * 100).toStringAsFixed(0)}%)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                rate >= 0.8
                    ? const Color(0xFF4CAF50)
                    : rate >= 0.5
                        ? const Color(0xFFFF9800)
                        : const Color(0xFFF44336),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Weekly mini chart
          _buildWeeklyChart(),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((day) {
        final completed = streakCounter.isCompleted(day);
        final weekdayLabels = ['一', '二', '三', '四', '五', '六', '日'];
        final label = weekdayLabels[(day.weekday - 1) % 7];

        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: completed
                    ? const Color(0xFF4CAF50)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: completed
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
