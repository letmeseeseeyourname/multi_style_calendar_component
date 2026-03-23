import 'package:flutter/material.dart';
import '../models/calendar_config.dart';
import '../models/date_range.dart';
import '../utils/date_utils.dart';

/// Controls date selection state, supporting single, multiple, and range modes.
///
/// Call [onDateTap] when the user taps a date. The controller automatically
/// manages selection state based on the current [SelectionMode] and notifies
/// listeners of changes.
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

  /// Changes the selection mode and clears any existing selection.
  void setMode(SelectionMode mode) {
    _mode = mode;
    clearSelection();
  }

  /// Handles a date tap, updating the selection based on the current mode.
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

  /// Returns `true` if [date] is currently selected (in any mode).
  bool isSelected(DateTime date) {
    final dateOnly = CalendarDateUtils.dateOnly(date);
    switch (_mode) {
      case SelectionMode.none:
        return false;
      case SelectionMode.single:
        return _selectedDate != null &&
            CalendarDateUtils.isSameDay(_selectedDate!, dateOnly);
      case SelectionMode.multiple:
        return _selectedDates.any(
          (d) => CalendarDateUtils.isSameDay(d, dateOnly),
        );
      case SelectionMode.range:
        return isInRange(dateOnly);
    }
  }

  /// Returns `true` if [date] falls within the currently selected range.
  bool isInRange(DateTime date) {
    if (_rangeStart == null) return false;
    final dateOnly = CalendarDateUtils.dateOnly(date);
    if (_rangeEnd == null) {
      return CalendarDateUtils.isSameDay(_rangeStart!, dateOnly);
    }
    return !dateOnly.isBefore(_rangeStart!) && !dateOnly.isAfter(_rangeEnd!);
  }

  /// Returns `true` if [date] is the start of the selected range.
  bool isRangeStart(DateTime date) {
    return _rangeStart != null &&
        CalendarDateUtils.isSameDay(_rangeStart!, date);
  }

  /// Returns `true` if [date] is the end of the selected range.
  bool isRangeEnd(DateTime date) {
    return _rangeEnd != null && CalendarDateUtils.isSameDay(_rangeEnd!, date);
  }

  /// Clears all selection state and notifies listeners.
  void clearSelection() {
    _selectedDate = null;
    _selectedDates.clear();
    _rangeStart = null;
    _rangeEnd = null;
    _isSelectingRange = false;
    notifyListeners();
  }
}
