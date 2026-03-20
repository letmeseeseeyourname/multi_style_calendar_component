import 'package:flutter/material.dart';

import '../../core/models/calendar_event.dart';
import '../../l10n/app_localizations.dart';

/// 时间线视图中的事件条
class TimelineEvent extends StatelessWidget {
  /// 事件数据
  final CalendarEvent event;

  /// 事件条宽度
  final double width;

  /// 事件条高度
  final double height;

  /// 点击回调
  final VoidCallback? onTap;

  const TimelineEvent({
    super.key,
    required this.event,
    required this.width,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 确定亮度以自动选择文字颜色
    final luminance = event.color.computeLuminance();
    final textColor = luminance > 0.5 ? Colors.black87 : Colors.white;
    final l = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: _buildTooltip(),
        child: Container(
          width: width.clamp(20, double.infinity),
          height: height,
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: event.color.withValues(alpha: 0.3),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (width > 80 && event.duration.inDays > 0)
                Text(
                  l.nDays(event.duration.inDays + 1),
                  style: TextStyle(
                    fontSize: 9,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildTooltip() {
    final start = event.startTime;
    final end = event.endTime;
    final buffer = StringBuffer(event.title);
    buffer.write('\n${start.month}/${start.day}');
    if (!_isSameDay(start, end)) {
      buffer.write(' - ${end.month}/${end.day}');
    }
    if (event.description != null && event.description!.isNotEmpty) {
      buffer.write('\n${event.description}');
    }
    return buffer.toString();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
