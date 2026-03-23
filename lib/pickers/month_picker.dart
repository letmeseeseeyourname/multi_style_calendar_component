import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/color_schemes.dart';

/// Month picker dialog.
/// Returns a [DateTime] with year and month set (day=1), or null if cancelled.
class MonthPicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const MonthPicker({super.key, this.initialDate, this.minDate, this.maxDate});

  /// Shows the month picker dialog.
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => MonthPicker(
        initialDate: initialDate,
        minDate: minDate,
        maxDate: maxDate,
      ),
    );
  }

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  late int _displayYear;
  int? _selectedYear;
  int? _selectedMonth;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate ?? DateTime.now();
    _displayYear = initial.year;
    _selectedYear = initial.year;
    _selectedMonth = initial.month;
  }

  bool _isDisabled(int month) {
    final date = DateTime(_displayYear, month);
    if (widget.minDate != null) {
      final min = DateTime(widget.minDate!.year, widget.minDate!.month);
      if (date.isBefore(min)) return true;
    }
    if (widget.maxDate != null) {
      final max = DateTime(widget.maxDate!.year, widget.maxDate!.month);
      if (date.isAfter(max)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final now = DateTime.now();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
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
                    l.selectMonth,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (_selectedYear != null && _selectedMonth != null)
                        ? l.yearMonth(_selectedYear!, _selectedMonth!)
                        : l.notSelected,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Year navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => setState(() => _displayYear--),
                  ),
                  Text(
                    '$_displayYear${l.yearSuffix}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => setState(() => _displayYear++),
                  ),
                ],
              ),
            ),
            // Month grid (4 rows x 3 columns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(4, (row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: List.generate(3, (col) {
                        final month = row * 3 + col + 1;
                        final isSelected =
                            _selectedYear == _displayYear &&
                            _selectedMonth == month;
                        final isCurrent =
                            now.year == _displayYear && now.month == month;
                        final disabled = _isDisabled(month);

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Material(
                              color: isSelected
                                  ? CalendarColors.selected
                                  : isCurrent
                                  ? CalendarColors.today.withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: disabled
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedYear = _displayYear;
                                          _selectedMonth = month;
                                        });
                                      },
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: Text(
                                    l.monthName(month),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: disabled
                                          ? CalendarColors.disabled
                                          : isSelected
                                          ? Colors.white
                                          : null,
                                      fontWeight: (isCurrent || isSelected)
                                          ? FontWeight.bold
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
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
                    onPressed: (_selectedYear != null && _selectedMonth != null)
                        ? () => Navigator.of(
                            context,
                          ).pop(DateTime(_selectedYear!, _selectedMonth!))
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
