import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../core/models/calendar_config.dart';
import '../core/models/calendar_date.dart';
import '../core/utils/date_utils.dart';
import '../theme/color_schemes.dart';

/// 自由配置 Playground
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  bool _showLunar = true;
  bool _showWeekend = true;
  int _firstDayOfWeek = 1;
  SelectionMode _selectionMode = SelectionMode.single;

  // Range selection
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool _isSelectingRange = false;

  // Multi selection
  final Set<DateTime> _multiSelected = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.playground),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // 配置摘要
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Chip(label: Text('${l.lunarLabel}: ${_showLunar ? l.on_ : l.off_}')),
                const SizedBox(width: 8),
                Chip(label: Text('${l.startLabel}: ${_firstDayOfWeek == 1 ? l.monday : l.sunday}')),
                const SizedBox(width: 8),
                Chip(label: Text(_selectionMode.name)),
              ],
            ),
          ),
          // 日历头
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _currentMonth = DateTime.now());
                  },
                  child: Text(
                    l.yearMonth(_currentMonth.year, _currentMonth.month),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          // 周标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: List.generate(7, (i) {
                final wd = (_firstDayOfWeek + i - 1) % 7 + 1;
                final isWeekend = wd == 6 || wd == 7;
                return Expanded(
                  child: Center(
                    child: Text(
                      CalendarDateUtils.weekdayName(wd),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isWeekend && _showWeekend
                            ? CalendarColors.weekend
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // 日期网格
          Expanded(
            child: _buildGrid(),
          ),
          // 选择结果
          if (_selectedDate != null || _rangeStart != null || _multiSelected.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surfaceContainerHighest,
              width: double.infinity,
              child: Text(_getSelectionText(), style: theme.textTheme.bodyMedium),
            ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final days = CalendarDateUtils.daysInMonthGrid(
      _currentMonth,
      firstDayOfWeek: _firstDayOfWeek,
    );

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.75,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final date = days[index];
        final calDate = CalendarDate.fromDateTime(date);
        final isCurrentMonth = date.month == _currentMonth.month;
        final isSelected = _isDateSelected(date);
        final isInRange = _isDateInRange(date);

        return GestureDetector(
          onTap: () => _onDateTap(date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? CalendarColors.selected
                  : isInRange
                      ? CalendarColors.inRange
                      : calDate.isToday
                          ? CalendarColors.today.withValues(alpha: 0.15)
                          : null,
              borderRadius: BorderRadius.circular(8),
              border: calDate.isToday
                  ? Border.all(color: CalendarColors.today, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: calDate.isToday ? FontWeight.bold : null,
                    color: isSelected
                        ? Colors.white
                        : !isCurrentMonth
                            ? Colors.grey.shade400
                            : calDate.isWeekend && _showWeekend
                                ? CalendarColors.weekend
                                : null,
                  ),
                ),
                if (_showLunar && calDate.lunar != null)
                  Text(
                    calDate.solarTerm ??
                        calDate.lunarFestival ??
                        calDate.lunar!.dayChinese,
                    style: TextStyle(
                      fontSize: 9,
                      color: isSelected
                          ? Colors.white70
                          : calDate.solarTerm != null
                              ? Colors.red
                              : !isCurrentMonth
                                  ? Colors.grey.shade300
                                  : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isDateSelected(DateTime date) {
    final d = CalendarDateUtils.dateOnly(date);
    switch (_selectionMode) {
      case SelectionMode.single:
        return _selectedDate != null && CalendarDateUtils.isSameDay(_selectedDate!, d);
      case SelectionMode.multiple:
        return _multiSelected.any((s) => CalendarDateUtils.isSameDay(s, d));
      case SelectionMode.range:
        return (_rangeStart != null && CalendarDateUtils.isSameDay(_rangeStart!, d)) ||
            (_rangeEnd != null && CalendarDateUtils.isSameDay(_rangeEnd!, d));
      case SelectionMode.none:
        return false;
    }
  }

  bool _isDateInRange(DateTime date) {
    if (_selectionMode != SelectionMode.range) return false;
    if (_rangeStart == null || _rangeEnd == null) return false;
    final d = CalendarDateUtils.dateOnly(date);
    return d.isAfter(_rangeStart!) && d.isBefore(_rangeEnd!);
  }

  void _onDateTap(DateTime date) {
    setState(() {
      final d = CalendarDateUtils.dateOnly(date);
      switch (_selectionMode) {
        case SelectionMode.single:
          _selectedDate = d;
          break;
        case SelectionMode.multiple:
          if (_multiSelected.any((s) => CalendarDateUtils.isSameDay(s, d))) {
            _multiSelected.removeWhere((s) => CalendarDateUtils.isSameDay(s, d));
          } else {
            _multiSelected.add(d);
          }
          break;
        case SelectionMode.range:
          if (!_isSelectingRange) {
            _rangeStart = d;
            _rangeEnd = null;
            _isSelectingRange = true;
          } else {
            if (d.isBefore(_rangeStart!)) {
              _rangeEnd = _rangeStart;
              _rangeStart = d;
            } else {
              _rangeEnd = d;
            }
            _isSelectingRange = false;
          }
          break;
        case SelectionMode.none:
          break;
      }
    });
  }

  String _getSelectionText() {
    final l = AppLocalizations.of(context);
    switch (_selectionMode) {
      case SelectionMode.single:
        if (_selectedDate == null) return '';
        return l.selectedLabel('${_selectedDate!.month}/${_selectedDate!.day}');
      case SelectionMode.multiple:
        return l.nSelected(_multiSelected.length);
      case SelectionMode.range:
        if (_rangeStart == null) return '';
        if (_rangeEnd == null) return l.startingFrom('${_rangeStart!.month}/${_rangeStart!.day}');
        return '${_rangeStart!.month}/${_rangeStart!.day} ~ ${_rangeEnd!.month}/${_rangeEnd!.day}';
      case SelectionMode.none:
        return '';
    }
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final l = AppLocalizations.of(context);
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.configuration, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l.showLunar),
                    value: _showLunar,
                    onChanged: (v) {
                      setSheetState(() => _showLunar = v);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: Text(l.highlightWeekend),
                    value: _showWeekend,
                    onChanged: (v) {
                      setSheetState(() => _showWeekend = v);
                      setState(() {});
                    },
                  ),
                  ListTile(
                    title: Text(l.weekStartDay),
                    trailing: SegmentedButton<int>(
                      segments: [
                        ButtonSegment(value: 1, label: Text(l.monday)),
                        ButtonSegment(value: 7, label: Text(l.sunday)),
                      ],
                      selected: {_firstDayOfWeek},
                      onSelectionChanged: (v) {
                        setSheetState(() => _firstDayOfWeek = v.first);
                        setState(() {});
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(l.selectionMode),
                    trailing: DropdownButton<SelectionMode>(
                      value: _selectionMode,
                      items: SelectionMode.values.map((m) {
                        return DropdownMenuItem(value: m, child: Text(m.name));
                      }).toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setSheetState(() => _selectionMode = v);
                        setState(() {
                          _selectedDate = null;
                          _multiSelected.clear();
                          _rangeStart = null;
                          _rangeEnd = null;
                          _isSelectingRange = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
