import 'package:flutter/material.dart';
import '../../core/models/calendar_config.dart';
import '../../core/models/calendar_event.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/calendar_theme.dart';
import 'week_header.dart';
import 'month_grid.dart';

/// 月视图，组合 WeekHeader 和 MonthGrid，支持左右滑动切换月份
class MonthView extends StatefulWidget {
  final DateTime? initialMonth;
  final CalendarConfig config;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime>? onDateTap;
  final ValueChanged<DateTime>? onMonthChanged;

  const MonthView({
    super.key,
    this.initialMonth,
    this.config = const CalendarConfig(),
    this.events = const [],
    this.onDateTap,
    this.onMonthChanged,
  });

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  /// PageView 的初始页索引，用于支持前后各 1200 个月（约 100 年）的翻页
  static const int _initialPageIndex = 1200;

  late PageController _pageController;
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = _normalizeMonth(widget.initialMonth ?? DateTime.now());
    _pageController = PageController(initialPage: _initialPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 将 DateTime 规范化为当月 1 号
  DateTime _normalizeMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// 根据页面偏移量计算目标月份
  DateTime _monthFromPageIndex(int index) {
    final offset = index - _initialPageIndex;
    return DateTime(_currentMonth.year, _currentMonth.month + offset, 1);
  }

  void _onPageChanged(int index) {
    final newMonth = _monthFromPageIndex(index);
    widget.onMonthChanged?.call(newMonth);
  }

  void _onDateTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateTap?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CalendarTheme.of(context);

    return Column(
      children: [
        // 月份标题与导航
        _buildHeader(theme),
        const SizedBox(height: 4),
        // 周标题行
        WeekHeader(firstDayOfWeek: widget.config.firstDayOfWeek),
        const SizedBox(height: 4),
        // 可滑动的月网格
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final month = _monthFromPageIndex(index);
              return MonthGrid(
                month: month,
                config: widget.config,
                events: widget.events,
                selectedDate: _selectedDate,
                onDateTap: _onDateTap,
              );
            },
          ),
        ),
      ],
    );
  }

  /// 月份标题头：左箭头 + 年月文字 + 右箭头
  Widget _buildHeader(CalendarThemeData theme) {
    return SizedBox(
      height: 48,
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, _) {
          // 根据当前页面计算显示月份
          final page = _pageController.hasClients &&
                  _pageController.position.haveDimensions
              ? _pageController.page?.round() ?? _initialPageIndex
              : _initialPageIndex;
          final displayMonth = _monthFromPageIndex(page);
          final l = AppLocalizations.of(context);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                },
              ),
              Text(
                l.yearMonth(displayMonth.year, displayMonth.month),
                style: theme.headerTextStyle,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
