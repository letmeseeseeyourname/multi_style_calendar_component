import 'package:flutter/material.dart';

import '../../core/utils/date_utils.dart';
import '../../theme/color_schemes.dart';

/// 日程列表中的日期分组头
class AgendaGroup extends StatelessWidget {
  /// 该组对应的日期
  final DateTime date;

  /// 该日期下的事件数量
  final int eventCount;

  /// 点击回调
  final VoidCallback? onTap;

  const AgendaGroup({
    super.key,
    required this.date,
    this.eventCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = CalendarDateUtils.dateOnly(now);
    final dateOnly = CalendarDateUtils.dateOnly(date);
    final isToday = dateOnly == today;
    final isTomorrow = dateOnly == today.add(const Duration(days: 1));
    final isYesterday = dateOnly == today.subtract(const Duration(days: 1));
    final isPast = dateOnly.isBefore(today);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Row(
          children: [
            // 日期数字圆圈
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isToday ? CalendarColors.today : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday
                    ? null
                    : Border.all(
                        color: isPast
                            ? theme.dividerColor
                            : theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isToday
                      ? Colors.white
                      : isPast
                          ? theme.hintColor
                          : theme.textTheme.titleSmall?.color,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 日期文字
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getRelativeLabel(isToday, isTomorrow, isYesterday),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isToday ? CalendarColors.today : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${CalendarDateUtils.weekdayName(date.weekday, short: false)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${date.year}年${date.month}月${date.day}日',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            // 事件数量标签
            if (eventCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isToday
                      ? CalendarColors.today.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$eventCount 项',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isToday ? CalendarColors.today : theme.hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getRelativeLabel(bool isToday, bool isTomorrow, bool isYesterday) {
    if (isToday) return '今天';
    if (isTomorrow) return '明天';
    if (isYesterday) return '昨天';
    return '${date.month}月${date.day}日';
  }
}
