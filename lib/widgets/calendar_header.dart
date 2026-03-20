import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Calendar header with month/year title, navigation arrows, and today button.
class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final String? title;

  const CalendarHeader({
    super.key,
    required this.currentDate,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayTitle =
        title ?? DateFormat.yMMMM('zh_CN').format(currentDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Previous button
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
            tooltip: '上一页',
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ),

          // Title
          Expanded(
            child: GestureDetector(
              onTap: onToday,
              child: Text(
                displayTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // Next button
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
            tooltip: '下一页',
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(width: 4),

          // Today button
          FilledButton.tonal(
            onPressed: onToday,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('今天'),
          ),
        ],
      ),
    );
  }
}
