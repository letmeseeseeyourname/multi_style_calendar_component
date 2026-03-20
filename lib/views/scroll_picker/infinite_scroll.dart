import 'package:flutter/material.dart';

import '../../core/models/calendar_date.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/color_schemes.dart';

/// 无限滚动日期列表
/// 上下滚动可无限浏览日期，适合作为日期选择器
class InfiniteScrollDateList extends StatefulWidget {
  /// 初始聚焦日期
  final DateTime initialDate;

  /// 选中的日期
  final DateTime? selectedDate;

  /// 日期选中回调
  final ValueChanged<DateTime>? onDateSelected;

  /// 是否显示农历信息
  final bool showLunar;

  /// 是否显示事件指示
  final bool showEventIndicator;

  /// 每项高度
  final double itemHeight;

  /// 禁用日期集合
  final Set<DateTime>? disabledDates;

  /// 最早日期
  final DateTime? minDate;

  /// 最晚日期
  final DateTime? maxDate;

  const InfiniteScrollDateList({
    super.key,
    required this.initialDate,
    this.selectedDate,
    this.onDateSelected,
    this.showLunar = true,
    this.showEventIndicator = false,
    this.itemHeight = 64,
    this.disabledDates,
    this.minDate,
    this.maxDate,
  });

  @override
  State<InfiniteScrollDateList> createState() => _InfiniteScrollDateListState();
}

class _InfiniteScrollDateListState extends State<InfiniteScrollDateList> {
  /// 使用足够大的初始偏移，模拟双向无限滚动
  static const int _initialOffset = 10000;

  late final ScrollController _scrollController;
  late DateTime _baseDate;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _baseDate = CalendarDateUtils.dateOnly(widget.initialDate);
    _selectedDate = widget.selectedDate;

    // 定位到中间位置
    _scrollController = ScrollController(
      initialScrollOffset: _initialOffset * widget.itemHeight,
    );
  }

  @override
  void didUpdateWidget(covariant InfiniteScrollDateList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DateTime _dateForIndex(int index) {
    final offset = index - _initialOffset;
    return _baseDate.add(Duration(days: offset));
  }

  bool _isDisabled(DateTime date) {
    final dateOnly = CalendarDateUtils.dateOnly(date);
    if (widget.disabledDates?.contains(dateOnly) == true) return true;
    if (widget.minDate != null && dateOnly.isBefore(CalendarDateUtils.dateOnly(widget.minDate!))) return true;
    if (widget.maxDate != null && dateOnly.isAfter(CalendarDateUtils.dateOnly(widget.maxDate!))) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 回到今天按钮
        _buildTodayButton(theme),
        // 无限滚动列表
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemExtent: widget.itemHeight,
            // 足够大的 itemCount 来模拟无限滚动
            itemCount: _initialOffset * 2,
            itemBuilder: (context, index) {
              final date = _dateForIndex(index);
              return _buildDateItem(context, date);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTodayButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: _scrollToToday,
          icon: const Icon(Icons.today, size: 16),
          label: Text(AppLocalizations.of(context).today),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            textStyle: theme.textTheme.labelMedium,
          ),
        ),
      ),
    );
  }

  void _scrollToToday() {
    final today = CalendarDateUtils.dateOnly(DateTime.now());
    final daysDiff = today.difference(_baseDate).inDays;
    final targetIndex = _initialOffset + daysDiff;
    final targetOffset = targetIndex * widget.itemHeight;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildDateItem(BuildContext context, DateTime date) {
    final theme = Theme.of(context);
    final today = CalendarDateUtils.dateOnly(DateTime.now());
    final dateOnly = CalendarDateUtils.dateOnly(date);
    final isToday = dateOnly == today;
    final isSelected = _selectedDate != null &&
        CalendarDateUtils.isSameDay(dateOnly, _selectedDate!);
    final isDisabled = _isDisabled(date);
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    // 判断是否为月份第一天，显示月份分隔
    final isFirstOfMonth = date.day == 1;

    return Column(
      children: [
        if (isFirstOfMonth)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              AppLocalizations.of(context).yearMonth(date.year, date.month),
              style: theme.textTheme.labelSmall?.copyWith(
                color: CalendarColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Expanded(
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    setState(() => _selectedDate = dateOnly);
                    widget.onDateSelected?.call(dateOnly);
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? CalendarColors.selected.withValues(alpha: 0.1)
                    : null,
                border: Border(
                  left: isSelected
                      ? const BorderSide(
                          color: CalendarColors.selected,
                          width: 3,
                        )
                      : BorderSide.none,
                  bottom: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                  ),
                ),
              ),
              child: Opacity(
                opacity: isDisabled ? 0.35 : 1.0,
                child: Row(
                  children: [
                    // 日期数字 + 星期
                    SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${date.day}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight:
                                  isToday ? FontWeight.bold : FontWeight.w500,
                              color: isToday
                                  ? CalendarColors.today
                                  : isWeekend
                                      ? CalendarColors.weekend
                                      : null,
                            ),
                          ),
                          Text(
                            CalendarDateUtils.weekdayName(date.weekday,
                                short: false),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isWeekend
                                  ? CalendarColors.weekend.withValues(alpha: 0.7)
                                  : theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 农历信息
                    if (widget.showLunar)
                      Expanded(
                        child: _buildLunarInfo(theme, date),
                      )
                    else
                      const Spacer(),
                    // 今天标签
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: CalendarColors.today,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          AppLocalizations.of(context).today,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLunarInfo(ThemeData theme, DateTime date) {
    try {
      final calDate = CalendarDate.fromDateTime(date);
      final lunar = calDate.lunar;
      if (lunar == null) return const SizedBox();

      final displayText = calDate.solarTerm ??
          calDate.lunarFestival ??
          calDate.holidayName ??
          lunar.fullChinese;

      final isSpecial = calDate.solarTerm != null ||
          calDate.lunarFestival != null ||
          calDate.holidayName != null;

      return Text(
        displayText,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isSpecial ? CalendarColors.holiday : theme.hintColor,
          fontWeight: isSpecial ? FontWeight.w500 : null,
        ),
      );
    } catch (_) {
      return const SizedBox();
    }
  }
}
