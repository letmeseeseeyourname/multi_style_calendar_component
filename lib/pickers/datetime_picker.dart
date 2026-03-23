import 'package:flutter/material.dart';
import '../core/utils/date_utils.dart';
import '../l10n/app_localizations.dart';
import '../theme/color_schemes.dart';

/// Combined date and time picker dialog.
/// Returns a [DateTime] with both date and time set, or null if cancelled.
class DateTimePicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool use24HourFormat;

  const DateTimePicker({
    super.key,
    this.initialDateTime,
    this.minDate,
    this.maxDate,
    this.use24HourFormat = true,
  });

  /// Shows the date-time picker dialog.
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDateTime,
    DateTime? minDate,
    DateTime? maxDate,
    bool use24HourFormat = true,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => DateTimePicker(
        initialDateTime: initialDateTime,
        minDate: minDate,
        maxDate: maxDate,
        use24HourFormat: use24HourFormat,
      ),
    );
  }

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

enum _PickerTab { date, time }

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _displayMonth;
  DateTime? _selectedDate;
  int _selectedHour = 0;
  int _selectedMinute = 0;
  _PickerTab _currentTab = _PickerTab.date;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDateTime ?? DateTime.now();
    _selectedDate = CalendarDateUtils.dateOnly(initial);
    _selectedHour = initial.hour;
    _selectedMinute = initial.minute;
    _displayMonth = DateTime(initial.year, initial.month);
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

  DateTime? _buildResult() {
    if (_selectedDate == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedHour,
      _selectedMinute,
    );
  }

  String _formatTime() {
    final h = _selectedHour.toString().padLeft(2, '0');
    final m = _selectedMinute.toString().padLeft(2, '0');
    return '$h:$m';
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
                    l.selectDateTime,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedDate != null
                        ? '${l.yearMonthDay(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day)} ${_formatTime()}'
                        : l.notSelected,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Tab bar
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _currentTab = _PickerTab.date),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _currentTab == _PickerTab.date
                                ? CalendarColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: _currentTab == _PickerTab.date
                                ? CalendarColors.primary
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l.date,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _currentTab == _PickerTab.date
                                  ? CalendarColors.primary
                                  : null,
                              fontWeight: _currentTab == _PickerTab.date
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _currentTab = _PickerTab.time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _currentTab == _PickerTab.time
                                ? CalendarColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: _currentTab == _PickerTab.time
                                ? CalendarColors.primary
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l.time,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _currentTab == _PickerTab.time
                                  ? CalendarColors.primary
                                  : null,
                              fontWeight: _currentTab == _PickerTab.time
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _currentTab == _PickerTab.date
                  ? _buildDatePicker(theme)
                  : _buildTimePicker(theme),
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
                        ? () => Navigator.of(context).pop(_buildResult())
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

  Widget _buildDatePicker(ThemeData theme) {
    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    final gridDays = CalendarDateUtils.daysInMonthGrid(_displayMonth);

    return Column(
      key: const ValueKey('date'),
      mainAxisSize: MainAxisSize.min,
      children: [
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
                              () => _selectedDate = CalendarDateUtils.dateOnly(
                                date,
                              ),
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
      ],
    );
  }

  Widget _buildTimePicker(ThemeData theme) {
    return Padding(
      key: const ValueKey('time'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimeScrollWheel(
                value: _selectedHour,
                maxValue: 23,
                onChanged: (v) => setState(() => _selectedHour = v),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  ':',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _TimeScrollWheel(
                value: _selectedMinute,
                maxValue: 59,
                step: 1,
                onChanged: (v) => setState(() => _selectedMinute = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick time buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _quickTimeChip(theme, AppLocalizations.of(context).now, () {
                final now = DateTime.now();
                setState(() {
                  _selectedHour = now.hour;
                  _selectedMinute = now.minute;
                });
              }),
              _quickTimeChip(theme, '09:00', () {
                setState(() {
                  _selectedHour = 9;
                  _selectedMinute = 0;
                });
              }),
              _quickTimeChip(theme, '12:00', () {
                setState(() {
                  _selectedHour = 12;
                  _selectedMinute = 0;
                });
              }),
              _quickTimeChip(theme, '14:00', () {
                setState(() {
                  _selectedHour = 14;
                  _selectedMinute = 0;
                });
              }),
              _quickTimeChip(theme, '18:00', () {
                setState(() {
                  _selectedHour = 18;
                  _selectedMinute = 0;
                });
              }),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _quickTimeChip(ThemeData theme, String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: theme.textTheme.bodySmall),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

/// A scroll wheel for selecting hour or minute values.
class _TimeScrollWheel extends StatefulWidget {
  final int value;
  final int maxValue;
  final int step;
  final ValueChanged<int> onChanged;

  const _TimeScrollWheel({
    required this.value,
    required this.maxValue,
    this.step = 1,
    required this.onChanged,
  });

  @override
  State<_TimeScrollWheel> createState() => _TimeScrollWheelState();
}

class _TimeScrollWheelState extends State<_TimeScrollWheel> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.value ~/ widget.step,
    );
  }

  @override
  void didUpdateWidget(_TimeScrollWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final targetItem = widget.value ~/ widget.step;
    if (_controller.selectedItem != targetItem) {
      _controller.jumpToItem(targetItem);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = (widget.maxValue ~/ widget.step) + 1;

    return SizedBox(
      width: 64,
      height: 150,
      child: Stack(
        children: [
          // Selection highlight
          Center(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: CalendarColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Scroll wheel
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.5,
            onSelectedItemChanged: (index) {
              widget.onChanged(index * widget.step);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: itemCount,
              builder: (context, index) {
                final val = index * widget.step;
                final isSelected = val == widget.value;
                return Center(
                  child: Text(
                    val.toString().padLeft(2, '0'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? CalendarColors.primary : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
