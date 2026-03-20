import 'package:flutter/material.dart';
import '../theme/color_schemes.dart';

/// Year picker dialog.
/// Returns the selected year as [DateTime] (month=1, day=1) or null if cancelled.
class YearPicker extends StatefulWidget {
  final int? initialYear;
  final int? minYear;
  final int? maxYear;

  const YearPicker({
    super.key,
    this.initialYear,
    this.minYear,
    this.maxYear,
  });

  /// Shows the year picker dialog.
  static Future<DateTime?> show(
    BuildContext context, {
    int? initialYear,
    int? minYear,
    int? maxYear,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => YearPicker(
        initialYear: initialYear,
        minYear: minYear,
        maxYear: maxYear,
      ),
    );
  }

  @override
  State<YearPicker> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  late int _pageStartYear;
  late int _selectedYear;
  late final int _minYear;
  late final int _maxYear;
  static const int _pageSize = 12; // 4x3 grid

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear ?? DateTime.now().year;
    _minYear = widget.minYear ?? 1900;
    _maxYear = widget.maxYear ?? 2100;
    // Align page start so selected year is visible
    _pageStartYear = _selectedYear - (_selectedYear - _minYear) % _pageSize;
  }

  void _previousPage() {
    final newStart = _pageStartYear - _pageSize;
    if (newStart >= _minYear - _pageSize) {
      setState(() => _pageStartYear = newStart);
    }
  }

  void _nextPage() {
    final newStart = _pageStartYear + _pageSize;
    if (newStart <= _maxYear + _pageSize) {
      setState(() => _pageStartYear = newStart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;

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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选择年份',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_selectedYear年',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Year range navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _previousPage,
                  ),
                  Text(
                    '$_pageStartYear - ${_pageStartYear + _pageSize - 1}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
            // Year grid (4 rows x 3 columns)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(4, (row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: List.generate(3, (col) {
                        final year = _pageStartYear + row * 3 + col;
                        final isSelected = year == _selectedYear;
                        final isCurrent = year == currentYear;
                        final disabled = year < _minYear || year > _maxYear;

                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            child: Material(
                              color: isSelected
                                  ? CalendarColors.selected
                                  : isCurrent
                                      ? CalendarColors.today
                                          .withValues(alpha: 0.1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: disabled
                                    ? null
                                    : () => setState(
                                        () => _selectedYear = year),
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$year',
                                    style:
                                        theme.textTheme.bodyMedium?.copyWith(
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
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.of(context)
                        .pop(DateTime(_selectedYear)),
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
