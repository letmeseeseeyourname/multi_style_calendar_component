import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import 'time_slot_picker.dart';
import 'availability_grid.dart';

/// 预约日历组件
class BookingCalendar extends StatefulWidget {
  const BookingCalendar({super.key});

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;
  late Map<String, bool> _weekAvailability;
  late Map<String, int> _dayBookingCounts;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _weekAvailability = generateMockAvailability();
    _dayBookingCounts = _generateDayBookingCounts();
  }

  Map<String, int> _generateDayBookingCounts() {
    final counts = <String, int>{};
    final daysInMonth = CalendarDateUtils.daysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    for (int d = 1; d <= daysInMonth; d++) {
      final hash = (d * 13 + _currentMonth.month * 7) % 8;
      counts['$d'] = hash;
    }
    return counts;
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
        1,
      );
      _dayBookingCounts = _generateDayBookingCounts();
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header info
          _buildInfoCard(),
          const SizedBox(height: 16),
          // Month navigation
          _buildMonthHeader(),
          const SizedBox(height: 8),
          // Weekday header
          _buildWeekdayHeader(),
          const SizedBox(height: 4),
          // Calendar grid
          _buildCalendarGrid(gridDays),
          const SizedBox(height: 16),
          // Time slot picker for selected date
          if (_selectedDate != null)
            TimeSlotPicker(date: _selectedDate!, slots: generateMockSlots()),
          if (_selectedDate == null) ...[
            // Weekly availability grid
            AvailabilityGrid(
              weekStart: CalendarDateUtils.firstDayOfWeek(DateTime.now()),
              availability: _weekAvailability,
              onSlotTap: (slot) {
                setState(() => _selectedDate = slot.$1);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.bookingManagement,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l.selectDateForSlots,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  l.monthlyBookings,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                Text(
                  '12',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
        return Expanded(
          child: Center(
            child: Text(
              CalendarDateUtils.weekdayName(weekday),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> gridDays) {
    final now = DateTime.now();
    final rows = <Widget>[];

    for (int i = 0; i < gridDays.length; i += 7) {
      rows.add(
        Row(
          children: List.generate(7, (j) {
            final date = gridDays[i + j];
            final isCurrentMonth = date.month == _currentMonth.month;
            final isToday = CalendarDateUtils.isSameDay(date, now);
            final isPast = date.isBefore(
              DateTime(now.year, now.month, now.day),
            );
            final isSelected =
                _selectedDate != null &&
                CalendarDateUtils.isSameDay(date, _selectedDate!);
            final bookingCount = isCurrentMonth
                ? (_dayBookingCounts['${date.day}'] ?? 0)
                : 0;

            return Expanded(
              child: GestureDetector(
                onTap: (isCurrentMonth && !isPast)
                    ? () => setState(() => _selectedDate = date)
                    : null,
                child: Container(
                  height: 52,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2196F3).withValues(alpha: 0.15)
                        : null,
                    borderRadius: BorderRadius.circular(6),
                    border: isToday
                        ? Border.all(color: const Color(0xFF2196F3), width: 1.5)
                        : isSelected
                        ? Border.all(color: const Color(0xFF2196F3))
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: !isCurrentMonth
                              ? Colors.grey.shade300
                              : isPast
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      if (isCurrentMonth && bookingCount > 0 && !isPast)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: bookingCount > 5
                                ? const Color(
                                    0xFFF44336,
                                  ).withValues(alpha: 0.15)
                                : const Color(
                                    0xFF4CAF50,
                                  ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            AppLocalizations.of(
                              context,
                            ).availableSlots(bookingCount),
                            style: TextStyle(
                              fontSize: 8,
                              color: bookingCount > 5
                                  ? const Color(0xFFF44336)
                                  : const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }
    return Column(children: rows);
  }
}
