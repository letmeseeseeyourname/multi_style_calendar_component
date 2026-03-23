import 'package:flutter/material.dart';
import '../core/utils/date_utils.dart';
import '../l10n/app_localizations.dart';
import '../theme/color_schemes.dart';

/// Single date picker dialog.
/// Returns the selected [DateTime] or null if cancelled.
class SingleDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const SingleDatePicker({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
  });

  /// Shows the single date picker dialog.
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => SingleDatePicker(
        initialDate: initialDate,
        minDate: minDate,
        maxDate: maxDate,
      ),
    );
  }

  @override
  State<SingleDatePicker> createState() => _SingleDatePickerState();
}

class _SingleDatePickerState extends State<SingleDatePicker> {
  late DateTime _displayMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayMonth = widget.initialDate ?? DateTime.now();
    _displayMonth = DateTime(_displayMonth.year, _displayMonth.month);
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.selectDate,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedDate != null
                        ? l.yearMonthDay(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                          )
                        : l.notSelected,
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
                  final wd = (i + 1) % 7 + 1; // Mon=1..Sun=7
                  final isWeekend = wd == 6 || wd == 7;
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
                      final isCurrentMonth = CalendarDateUtils.isSameMonth(
                        date,
                        _displayMonth,
                      );
                      final isToday = CalendarDateUtils.isSameDay(date, now);
                      final isSelected =
                          _selectedDate != null &&
                          CalendarDateUtils.isSameDay(date, _selectedDate!);
                      final disabled = _isDisabled(date);
                      final isWeekend = date.weekday == 6 || date.weekday == 7;

                      return Expanded(
                        child: GestureDetector(
                          onTap: (disabled || !isCurrentMonth)
                              ? null
                              : () => setState(
                                  () => _selectedDate =
                                      CalendarDateUtils.dateOnly(date),
                                ),
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? CalendarColors.selected
                                  : isToday
                                  ? CalendarColors.today.withValues(alpha: 0.1)
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
                                    : isSelected
                                    ? Colors.white
                                    : isWeekend
                                    ? CalendarColors.weekend
                                    : null,
                                fontWeight: isToday ? FontWeight.bold : null,
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
                    onPressed: _selectedDate != null
                        ? () => Navigator.of(context).pop(_selectedDate)
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
