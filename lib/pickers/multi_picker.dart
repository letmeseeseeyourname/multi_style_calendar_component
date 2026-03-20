import 'package:flutter/material.dart';
import '../core/utils/date_utils.dart';
import '../theme/color_schemes.dart';

/// Multi-select date picker dialog.
/// Returns a [Set<DateTime>] of selected dates or null if cancelled.
class MultiDatePicker extends StatefulWidget {
  final Set<DateTime>? initialDates;
  final DateTime? minDate;
  final DateTime? maxDate;
  final int? maxSelections;

  const MultiDatePicker({
    super.key,
    this.initialDates,
    this.minDate,
    this.maxDate,
    this.maxSelections,
  });

  /// Shows the multi-select date picker dialog.
  static Future<Set<DateTime>?> show(
    BuildContext context, {
    Set<DateTime>? initialDates,
    DateTime? minDate,
    DateTime? maxDate,
    int? maxSelections,
  }) {
    return showDialog<Set<DateTime>>(
      context: context,
      builder: (_) => MultiDatePicker(
        initialDates: initialDates,
        minDate: minDate,
        maxDate: maxDate,
        maxSelections: maxSelections,
      ),
    );
  }

  @override
  State<MultiDatePicker> createState() => _MultiDatePickerState();
}

class _MultiDatePickerState extends State<MultiDatePicker> {
  late DateTime _displayMonth;
  late Set<DateTime> _selectedDates;

  @override
  void initState() {
    super.initState();
    _selectedDates = widget.initialDates
            ?.map((d) => CalendarDateUtils.dateOnly(d))
            .toSet() ??
        {};
    final ref = widget.initialDates?.firstOrNull ?? DateTime.now();
    _displayMonth = DateTime(ref.year, ref.month);
  }

  bool _isDisabled(DateTime date) {
    final d = CalendarDateUtils.dateOnly(date);
    if (widget.minDate != null &&
        d.isBefore(CalendarDateUtils.dateOnly(widget.minDate!))) {
      return true;
    }
    if (widget.maxDate != null &&
        d.isAfter(CalendarDateUtils.dateOnly(widget.maxDate!))) {
      return true;
    }
    return false;
  }

  bool _isSelected(DateTime date) {
    final d = CalendarDateUtils.dateOnly(date);
    return _selectedDates.any((s) => CalendarDateUtils.isSameDay(s, d));
  }

  void _toggleDate(DateTime date) {
    final d = CalendarDateUtils.dateOnly(date);
    setState(() {
      if (_isSelected(d)) {
        _selectedDates.removeWhere((s) => CalendarDateUtils.isSameDay(s, d));
      } else {
        if (widget.maxSelections != null &&
            _selectedDates.length >= widget.maxSelections!) {
          return;
        }
        _selectedDates.add(d);
      }
    });
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final gridDays = CalendarDateUtils.daysInMonthGrid(_displayMonth);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CalendarColors.primary,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选择多个日期',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '已选择 ${_selectedDates.length} 天',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Month navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _previousMonth,
                  ),
                  Text(
                    '${_displayMonth.year}年 ${CalendarDateUtils.monthName(_displayMonth.month)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
            // Weekday headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(7, (i) {
                  final isWeekend = (i + 1) == 6 || (i + 1) == 7;
                  return Expanded(
                    child: Center(
                      child: Text(
                        CalendarDateUtils.weekdayName(i + 1),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isWeekend ? CalendarColors.weekend : null,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),
            // Day grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: List.generate(6, (row) {
                  return Row(
                    children: List.generate(7, (col) {
                      final date = gridDays[row * 7 + col];
                      final isCurrentMonth =
                          CalendarDateUtils.isSameMonth(date, _displayMonth);
                      final isToday = CalendarDateUtils.isSameDay(date, now);
                      final selected = _isSelected(date);
                      final disabled = _isDisabled(date);
                      final isWeekend =
                          date.weekday == 6 || date.weekday == 7;

                      return Expanded(
                        child: GestureDetector(
                          onTap: (disabled || !isCurrentMonth)
                              ? null
                              : () => _toggleDate(date),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: selected
                                  ? CalendarColors.selected
                                  : isToday
                                      ? CalendarColors.today
                                          .withValues(alpha: 0.1)
                                      : null,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${date.day}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: !isCurrentMonth
                                    ? CalendarColors.disabled
                                    : disabled
                                        ? CalendarColors.disabled
                                        : selected
                                            ? Colors.white
                                            : isWeekend
                                                ? CalendarColors.weekend
                                                : null,
                                fontWeight:
                                    (isToday || selected) ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            // Action buttons
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selectedDates.clear()),
                    child: const Text('清空'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _selectedDates.isNotEmpty
                        ? () => Navigator.of(context).pop(_selectedDates)
                        : null,
                    child: const Text('确定'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
