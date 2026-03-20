import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../l10n/app_localizations.dart';

/// 日程列表中的单个事件项
class AgendaItem extends StatelessWidget {
  /// 事件数据
  final CalendarEvent event;

  /// 点击事件回调
  final VoidCallback? onTap;

  /// 长按事件回调
  final VoidCallback? onLongPress;

  const AgendaItem({
    super.key,
    required this.event,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 40, bottom: 6),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(
                color: event.color,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              // 时间列
              SizedBox(
                width: 56,
                child: _buildTimeColumn(context, theme),
              ),
              const SizedBox(width: 12),
              // 内容列
              Expanded(
                child: _buildContentColumn(theme),
              ),
              // 右侧箭头
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.hintColor.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeColumn(BuildContext context, ThemeData theme) {
    if (event.isAllDay) {
      return Text(
        AppLocalizations.of(context).allDay,
        style: theme.textTheme.labelMedium?.copyWith(
          color: event.color,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final startHour = event.startTime.hour.toString().padLeft(2, '0');
    final startMin = event.startTime.minute.toString().padLeft(2, '0');
    final endHour = event.endTime.hour.toString().padLeft(2, '0');
    final endMin = event.endTime.minute.toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$startHour:$startMin',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '$endHour:$endMin',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildContentColumn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (event.description != null && event.description!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            event.description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (event.location != null && event.location!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 12,
                color: theme.hintColor,
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  event.location!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.hintColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
