import 'package:flutter/material.dart';
import '../models/calendar_config.dart';
import '../models/date_range.dart';
import '../utils/date_utils.dart';

/// 日期选择控制器
class SelectionController extends ChangeNotifier {
  SelectionMode _mode;
  DateTime? _selectedDate;
  final Set<DateTime> _selectedDates = {};
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool _isSelectingRange = false;

  SelectionController({SelectionMode mode = SelectionMode.single})
      : _mode = mode;

  SelectionMode get mode => _mode;
  DateTime? get selectedDate => _selectedDate;
  Set<DateTime> get selectedDates => Set.unmodifiable(_selectedDates);
  DateTime? get rangeStart => _rangeStart;
  DateTime? get rangeEnd => _rangeEnd;

  DateRange? get selectedRange {
    if (_rangeStart != null && _rangeEnd != null) {
      return DateRange(_rangeStart!, _rangeEnd!);
    }
    return null;
  }

  void setMode(SelectionMode mode) {
    _mode = mode;
    clearSelection();
  }

  void onDateTap(DateTime date) {
    final dateOnly = CalendarDateUtils.dateOnly(date);

    switch (_mode) {
      case SelectionMode.none:
        break;
      case SelectionMode.single:
        _selectedDate = dateOnly;
        break;
      case SelectionMode.multiple:
        if (_selectedDates.contains(dateOnly)) {
          _selectedDates.remove(dateOnly);
        } else {
          _selectedDates.add(dateOnly);
        }
        break;
      case SelectionMode.range:
        _handleRangeSelection(dateOnly);
        break;
    }
    notifyListeners();
  }

  void _handleRangeSelection(DateTime date) {
    if (!_isSelectingRange) {
      _rangeStart = date;
      _rangeEnd = null;
      _isSelectingRange = true;
    } else {
      if (date.isBefore(_rangeStart!)) {
        _rangeEnd = _rangeStart;
        _rangeStart = date;
      } else {
        _rangeEnd = date;
      }
      _isSelectingRange = false;
    }
  }

  bool isSelected(DateTime date) {
    final dateOnly = CalendarDateUtils.dateOnly(date);
    switch (_mode) {
      case SelectionMode.none:
        return false;
      case SelectionMode.single:
        return _selectedDate != null &&
            CalendarDateUtils.isSameDay(_selectedDate!, dateOnly);
      case SelectionMode.multiple:
        return _selectedDates.any((d) => CalendarDateUtils.isSameDay(d, dateOnly));
      case SelectionMode.range:
        return isInRange(dateOnly);
    }
  }

  bool isInRange(DateTime date) {
    if (_rangeStart == null) return false;
    final dateOnly = CalendarDateUtils.dateOnly(date);
    if (_rangeEnd == null) {
      return CalendarDateUtils.isSameDay(_rangeStart!, dateOnly);
    }
    return !dateOnly.isBefore(_rangeStart!) && !dateOnly.isAfter(_rangeEnd!);
  }

  bool isRangeStart(DateTime date) {
    return _rangeStart != null && CalendarDateUtils.isSameDay(_rangeStart!, date);
  }

  bool isRangeEnd(DateTime date) {
    return _rangeEnd != null && CalendarDateUtils.isSameDay(_rangeEnd!, date);
  }

  void clearSelection() {
    _selectedDate = null;
    _selectedDates.clear();
    _rangeStart = null;
    _rangeEnd = null;
    _isSelectingRange = false;
    notifyListeners();
  }
}
