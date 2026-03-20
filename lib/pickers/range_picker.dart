import 'package:flutter/material.dart';
import '../core/models/date_range.dart';
import '../core/utils/date_utils.dart';
import '../l10n/app_localizations.dart';
import '../theme/color_schemes.dart';

/// Date range picker dialog.
/// Returns a [DateRange] with start and end dates, or null if cancelled.
class DateRangePicker extends StatefulWidget {
  final DateRange? initialRange;
  final DateTime? minDate;
  final DateTime? maxDate;

  const DateRangePicker({
    super.key,
    this.initialRange,
    this.minDate,
    this.maxDate,
  });

  /// Shows the date range picker dialog.
  static Future<DateRange?> show(
    BuildContext context, {
    DateRange? initialRange,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    return showDialog<DateRange>(
      context: context,
      builder: (_) => DateRangePicker(
        initialRange: initialRange,
        minDate: minDate,
        maxDate: maxDate,
      ),
    );
  }

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTime _displayMonth;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _selectingEnd = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialRange != null) {
      _startDate = CalendarDateUtils.dateOnly(widget.initialRange!.start);
      _endDate = CalendarDateUtils.dateOnly(widget.initialRange!.end);
      _displayMonth = DateTime(_startDate!.year, _startDate!.month);
    } else {
      _displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
    }
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

  bool _isInRange(DateTime date) {
    if (_startDate == null || _endDate == null) return false;
    final d = CalendarDateUtils.dateOnly(date);
    return !d.isBefore(_startDate!) && !d.isAfter(_endDate!);
  }

  bool _isRangeStart(DateTime date) {
    return _startDate != null && CalendarDateUtils.isSameDay(date, _startDate!);
  }

  bool _isRangeEnd(DateTime date) {
    return _endDate != null && CalendarDateUtils.isSameDay(date, _endDate!);
  }

  void _onDateTap(DateTime date) {
    final d = CalendarDateUtils.dateOnly(date);
    setState(() {
      if (!_selectingEnd || _startDate == null) {
        _startDate = d;
        _endDate = null;
        _selectingEnd = true;
      } else {
        if (d.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = d;
        } else {
          _endDate = d;
        }
        _selectingEnd = false;
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

  String _formatHeader(AppLocalizations l) {
    if (_startDate == null) return l.selectStartDate;
    if (_endDate == null) {
      return '${l.monthDay(_startDate!.month, _startDate!.day)}${l.selectEndDate(0)}';
    }
    final days = _endDate!.difference(_startDate!).inDays + 1;
    return '${l.monthDay(_startDate!.month, _startDate!.day)} - ${l.monthDay(_endDate!.month, _endDate!.day)} (${l.nDays(days)})';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
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
                    l.selectRange,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatHeader(l),
                    style: theme.textTheme.titleMedium?.copyWith(
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
                    l.yearMonth(_displayMonth.year, _displayMonth.month),
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
                        l.weekdayShort(i + 1),
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
                      final disabled = _isDisabled(date);
                      final isStart = _isRangeStart(date);
                      final isEnd = _isRangeEnd(date);
                      final inRange = _isInRange(date);
                      final isWeekend =
                          date.weekday == 6 || date.weekday == 7;

                      Color? bgColor;
                      Color? textColor;
                      BoxShape shape = BoxShape.circle;

                      if (isStart || isEnd) {
                        bgColor = CalendarColors.selected;
                        textColor = Colors.white;
                      } else if (inRange && isCurrentMonth) {
                        bgColor = CalendarColors.inRange;
                      }

                      if (!isCurrentMonth || disabled) {
                        textColor = CalendarColors.disabled;
                        bgColor = null;
                      } else if (isWeekend && !isStart && !isEnd) {
                        textColor ??= CalendarColors.weekend;
                      }

                      // Use a rounded rectangle for range middle cells
                      BorderRadius? borderRadius;
                      if (inRange && !isStart && !isEnd && isCurrentMonth) {
                        shape = BoxShape.rectangle;
                        borderRadius = BorderRadius.zero;
                      }
                      if (isStart) {
                        shape = BoxShape.rectangle;
                        borderRadius = const BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(20),
                        );
                        if (_endDate != null) {
                          borderRadius = const BorderRadius.horizontal(
                            left: Radius.circular(20),
                          );
                        }
                      }
                      if (isEnd) {
                        shape = BoxShape.rectangle;
                        borderRadius = const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        );
                      }
                      if (isStart && isEnd) {
                        shape = BoxShape.circle;
                        borderRadius = null;
                      }

                      return Expanded(
                        child: GestureDetector(
                          onTap: (disabled || !isCurrentMonth)
                              ? null
                              : () => _onDateTap(date),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            decoration: BoxDecoration(
                              color: bgColor,
                              shape: shape,
                              borderRadius: borderRadius,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${date.day}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: textColor,
                                fontWeight:
                                    (isToday || isStart || isEnd) ? FontWeight.bold : null,
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: (_startDate != null && _endDate != null)
                        ? () => Navigator.of(context)
                            .pop(DateRange(_startDate!, _endDate!))
                        : null,
                    child: Text(l.confirm),
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
