import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import 'attendance_status.dart';
import 'attendance_stats.dart';

/// 考勤日历组件
class AttendanceCalendar extends StatefulWidget {
  const AttendanceCalendar({super.key});

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  late DateTime _currentMonth;
  late Map<String, AttendanceRecord> _records;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _records = generateMockAttendanceData(_currentMonth);
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
        1,
      );
      _records = generateMockAttendanceData(_currentMonth);
      _selectedDate = null;
    });
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Stats summary
          AttendanceStats(records: _records, month: _currentMonth),
          const SizedBox(height: 16),
          // Month header
          _buildMonthHeader(),
          const SizedBox(height: 8),
          // Weekday header
          _buildWeekdayHeader(),
          const SizedBox(height: 4),
          // Calendar grid
          _buildCalendarGrid(gridDays),
          // Legend
          const SizedBox(height: 16),
          _buildLegend(),
          // Selected date detail
          if (_selectedDate != null) ...[
            const SizedBox(height: 16),
            _buildDateDetail(),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _changeMonth(-1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          AppLocalizations.of(
            context,
          ).yearMonth(_currentMonth.year, _currentMonth.month),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => _changeMonth(1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    return Row(
      children: List.generate(7, (index) {
        final weekday = (index + 1) % 7 == 0 ? 7 : (index + 1);
        final isWeekend = weekday == 6 || weekday == 7;
        return Expanded(
          child: Center(
            child: Text(
              CalendarDateUtils.weekdayName(weekday),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isWeekend ? Colors.red.shade300 : Colors.grey.shade600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> gridDays) {
    final rows = <Widget>[];
    for (int i = 0; i < gridDays.length; i += 7) {
      rows.add(
        Row(
          children: List.generate(7, (j) {
            final date = gridDays[i + j];
            final isCurrentMonth = date.month == _currentMonth.month;
            final record = _records[_dateKey(date)];
            final isSelected =
                _selectedDate != null &&
                CalendarDateUtils.isSameDay(date, _selectedDate!);

            return Expanded(
              child: GestureDetector(
                onTap: isCurrentMonth
                    ? () => setState(() => _selectedDate = date)
                    : null,
                child: _AttendanceDayCell(
                  date: date,
                  record: record,
                  isCurrentMonth: isCurrentMonth,
                  isSelected: isSelected,
                  isToday: CalendarDateUtils.isSameDay(date, DateTime.now()),
                ),
              ),
            );
          }),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildLegend() {
    final l = AppLocalizations.of(context);
    final statuses = [
      AttendanceStatus.normal,
      AttendanceStatus.late,
      AttendanceStatus.leaveEarly,
      AttendanceStatus.absent,
      AttendanceStatus.leave,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: statuses.map((status) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: status.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              status.localizedLabel(l),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDateDetail() {
    final l = AppLocalizations.of(context);
    final record = _records[_dateKey(_selectedDate!)];
    if (record == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          l.noAttendanceRecord(_selectedDate!.month, _selectedDate!.day),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: record.status.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: record.status.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(record.status.icon, color: record.status.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l.monthDay(_selectedDate!.month, _selectedDate!.day)} - ${record.status.localizedLabel(l)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l.checkIn}: ${record.checkInText}  ${l.checkOut}: ${record.checkOutText}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                if (record.note != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${l.remark}: ${record.note}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceDayCell extends StatelessWidget {
  final DateTime date;
  final AttendanceRecord? record;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;

  const _AttendanceDayCell({
    required this.date,
    this.record,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final status = record?.status;

    return Container(
      height: 52,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF2196F3).withValues(alpha: 0.15)
            : status != null
            ? status.color.withValues(alpha: 0.08)
            : null,
        borderRadius: BorderRadius.circular(6),
        border: isToday
            ? Border.all(color: const Color(0xFF2196F3), width: 1.5)
            : isSelected
            ? Border.all(color: const Color(0xFF2196F3), width: 1)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isCurrentMonth
                  ? (isToday ? const Color(0xFF2196F3) : Colors.black87)
                  : Colors.grey.shade300,
            ),
          ),
          if (isCurrentMonth && status != null)
            Icon(status.icon, size: 12, color: status.color),
          if (isCurrentMonth && record?.checkInTime != null)
            Text(
              record!.checkInText,
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
