import 'package:flutter/material.dart';
import '../../core/models/calendar_date.dart';
import '../../core/models/calendar_event.dart';
import '../../theme/calendar_theme.dart';

/// A single day cell in the month grid view.
///
/// Displays the Gregorian day number, an optional lunar calendar label
/// (solar term, festival, or lunar day), and up to 3 colored event dots.
/// Highlights today and selected states with themed decorations.
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
              Text('${date.gregorian.day}', style: _dayTextStyle(theme)),
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

  /// Builds the cell decoration (highlights for today and selected states).
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
    return BoxDecoration(borderRadius: BorderRadius.circular(theme.cellRadius));
  }

  /// Returns the text style for the day number.
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
      return theme.dayTextStyle.copyWith(color: theme.weekendColor);
    }
    return theme.dayTextStyle;
  }

  /// Returns the text style for the lunar calendar label.
  TextStyle _lunarTextStyle(CalendarThemeData theme) {
    final isSpecial =
        date.solarTerm != null ||
        date.lunarFestival != null ||
        date.holidayName != null;

    if (isSelected || date.isToday) {
      return theme.lunarTextStyle.copyWith(color: Colors.white70);
    }
    if (isSpecial) {
      return theme.lunarTextStyle.copyWith(color: theme.holidayColor);
    }
    return theme.lunarTextStyle;
  }

  /// Returns the lunar display text. Priority: solar term > lunar festival > holiday > lunar day.
  String _lunarDisplayText() {
    if (date.solarTerm != null) return date.solarTerm!;
    if (date.lunarFestival != null) return date.lunarFestival!;
    if (date.holidayName != null) return date.holidayName!;
    if (date.lunar != null) return date.lunar!.dayChinese;
    return '';
  }

  /// Builds up to 3 colored event indicator dots.
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
            color: (isSelected || date.isToday) ? Colors.white70 : event.color,
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }
}
