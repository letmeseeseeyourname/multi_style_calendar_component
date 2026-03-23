import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'wheel_picker.dart';

/// 滚动式日期选择器
/// 包含年、月、日三个 CupertinoPicker 风格的滚轮
class ScrollDatePicker extends StatefulWidget {
  /// 初始日期
  final DateTime initialDate;

  /// 最早可选日期
  final DateTime? minDate;

  /// 最晚可选日期
  final DateTime? maxDate;

  /// 日期变化回调
  final ValueChanged<DateTime>? onDateChanged;

  /// 滚轮高度
  final double wheelHeight;

  /// 单项高度
  final double itemExtent;

  /// 是否显示年份
  final bool showYear;

  /// 是否显示确认按钮
  final bool showConfirmButton;

  /// 确认回调
  final ValueChanged<DateTime>? onConfirm;

  const ScrollDatePicker({
    super.key,
    required this.initialDate,
    this.minDate,
    this.maxDate,
    this.onDateChanged,
    this.wheelHeight = 200,
    this.itemExtent = 40,
    this.showYear = true,
    this.showConfirmButton = false,
    this.onConfirm,
  });

  @override
  State<ScrollDatePicker> createState() => _ScrollDatePickerState();
}

class _ScrollDatePickerState extends State<ScrollDatePicker> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  late int _minYear;
  late int _maxYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
    _minYear = widget.minDate?.year ?? 1900;
    _maxYear = widget.maxDate?.year ?? 2100;
  }

  int get _daysInSelectedMonth {
    return DateTime(_selectedYear, _selectedMonth + 1, 0).day;
  }

  void _clampDay() {
    final maxDay = _daysInSelectedMonth;
    if (_selectedDay > maxDay) {
      _selectedDay = maxDay;
    }
  }

  void _notifyChange() {
    _clampDay();
    final date = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    widget.onDateChanged?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 标题
        if (widget.showConfirmButton) _buildHeader(context, theme),
        // 选中日期预览
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            l.yearMonthDay(_selectedYear, _selectedMonth, _selectedDay),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 滚轮区域
        SizedBox(
          height: widget.wheelHeight,
          child: Row(
            children: [
              // 年份滚轮
              if (widget.showYear)
                Expanded(
                  flex: 3,
                  child: WheelPicker(
                    itemCount: _maxYear - _minYear + 1,
                    initialIndex: _selectedYear - _minYear,
                    itemExtent: widget.itemExtent,
                    labelBuilder: (index) =>
                        '${_minYear + index}${l.yearSuffix}',
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedYear = _minYear + index;
                        _clampDay();
                      });
                      _notifyChange();
                    },
                  ),
                ),
              // 月份滚轮
              Expanded(
                flex: 2,
                child: WheelPicker(
                  itemCount: 12,
                  initialIndex: _selectedMonth - 1,
                  itemExtent: widget.itemExtent,
                  labelBuilder: (index) => '${index + 1}${l.monthSuffix}',
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMonth = index + 1;
                      _clampDay();
                    });
                    _notifyChange();
                  },
                ),
              ),
              // 日期滚轮
              Expanded(
                flex: 2,
                child: WheelPicker(
                  key: ValueKey('day_${_selectedYear}_$_selectedMonth'),
                  itemCount: _daysInSelectedMonth,
                  initialIndex: (_selectedDay - 1).clamp(
                    0,
                    _daysInSelectedMonth - 1,
                  ),
                  itemExtent: widget.itemExtent,
                  labelBuilder: (index) => '${index + 1}${l.daySuffix}',
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDay = index + 1;
                    });
                    _notifyChange();
                  },
                ),
              ),
            ],
          ),
        ),
        // 确认按钮
        if (widget.showConfirmButton)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final date = DateTime(
                    _selectedYear,
                    _selectedMonth,
                    _selectedDay,
                  );
                  widget.onConfirm?.call(date);
                },
                child: Text(l.confirmSelection),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: Text(l.cancel),
          ),
          Text(
            l.selectDate,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () {
              final date = DateTime(
                _selectedYear,
                _selectedMonth,
                _selectedDay,
              );
              widget.onConfirm?.call(date);
            },
            child: Text(l.confirmSelection),
          ),
        ],
      ),
    );
  }
}
