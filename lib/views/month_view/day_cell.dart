import 'package:flutter/material.dart';
import '../../core/models/calendar_date.dart';
import '../../core/models/calendar_event.dart';
import '../../theme/calendar_theme.dart';

/// 日期单元格，展示公历日期、农历文字和事件指示点
class DayCell extends StatelessWidget {
  final CalendarDate date;
  final List<CalendarEvent> events;
  final bool isSelected;
  final bool isCurrentMonth;
  final bool showLunar;
  final VoidCallback? onTap;

  const DayCell({
    super.key,
    required this.date,
    this.events = const [],
    this.isSelected = false,
    this.isCurrentMonth = true,
    this.showLunar = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CalendarTheme.of(context);
    final double opacity = isCurrentMonth ? 1.0 : 0.35;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: opacity,
        child: Container(
          decoration: _buildDecoration(theme),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 公历日期
              Text(
                '${date.gregorian.day}',
                style: _dayTextStyle(theme),
              ),
              // 农历信息
              if (showLunar) ...[
                const SizedBox(height: 1),
                Text(
                  _lunarDisplayText(),
                  style: _lunarTextStyle(theme),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // 事件指示点
              if (events.isNotEmpty) ...[
                const SizedBox(height: 2),
                _buildEventDots(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建单元格装饰（今天高亮、选中高亮）
  BoxDecoration _buildDecoration(CalendarThemeData theme) {
    if (isSelected) {
      return BoxDecoration(
        color: theme.selectedColor,
        borderRadius: BorderRadius.circular(theme.cellRadius),
      );
    }
    if (date.isToday) {
      return BoxDecoration(
        color: theme.todayColor,
        borderRadius: BorderRadius.circular(theme.cellRadius),
      );
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(theme.cellRadius),
    );
  }

  /// 日期数字文字样式
  TextStyle _dayTextStyle(CalendarThemeData theme) {
    // 选中或今天使用白色文字
    if (isSelected || date.isToday) {
      return theme.dayTextStyle.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      );
    }
    // 周末使用红色
    if (date.isWeekend) {
      return theme.dayTextStyle.copyWith(
        color: theme.weekendColor,
      );
    }
    return theme.dayTextStyle;
  }

  /// 农历文字样式
  TextStyle _lunarTextStyle(CalendarThemeData theme) {
    final isSpecial = date.solarTerm != null ||
        date.lunarFestival != null ||
        date.holidayName != null;

    if (isSelected || date.isToday) {
      return theme.lunarTextStyle.copyWith(
        color: Colors.white70,
      );
    }
    if (isSpecial) {
      return theme.lunarTextStyle.copyWith(
        color: theme.holidayColor,
      );
    }
    return theme.lunarTextStyle;
  }

  /// 农历显示文字，优先级: 节气 > 农历节日 > 节假日名 > 农历日
  String _lunarDisplayText() {
    if (date.solarTerm != null) return date.solarTerm!;
    if (date.lunarFestival != null) return date.lunarFestival!;
    if (date.holidayName != null) return date.holidayName!;
    if (date.lunar != null) return date.lunar!.dayChinese;
    return '';
  }

  /// 最多显示 3 个事件颜色点
  Widget _buildEventDots() {
    final dotEvents = events.take(3).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dotEvents.map((event) {
        return Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: (isSelected || date.isToday)
                ? Colors.white70
                : event.color,
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }
}
