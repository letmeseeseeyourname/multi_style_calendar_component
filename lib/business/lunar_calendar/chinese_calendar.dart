import 'package:flutter/material.dart';
import '../../../core/models/calendar_date.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/lunar_utils.dart';
import '../../../l10n/app_localizations.dart';
import 'festival_display.dart';
import 'fortune_display.dart';

/// 中国农历日历组件
class ChineseCalendar extends StatefulWidget {
  const ChineseCalendar({super.key});

  @override
  State<ChineseCalendar> createState() => _ChineseCalendarState();
}

class _ChineseCalendarState extends State<ChineseCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
        1,
      );
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);
    final lunarMonthInfo = CalendarDate.fromDateTime(_currentMonth);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Lunar month header
          _buildLunarHeader(lunarMonthInfo, l),
          const SizedBox(height: 12),
          // Month navigation
          _buildMonthHeader(l),
          const SizedBox(height: 8),
          // Weekday header
          _buildWeekdayHeader(),
          const SizedBox(height: 4),
          // Calendar grid
          _buildCalendarGrid(gridDays),
          // Selected date details
          if (_selectedDate != null) ...[
            const SizedBox(height: 16),
            _buildSelectedDateInfo(l),
            const SizedBox(height: 12),
            FestivalDisplay(
              date: _selectedDate!,
              solarTerm: CalendarDate.fromDateTime(_selectedDate!).solarTerm,
              lunarFestival: CalendarDate.fromDateTime(
                _selectedDate!,
              ).lunarFestival,
            ),
            const SizedBox(height: 12),
            FortuneDisplay(date: _selectedDate!),
          ],
        ],
      ),
    );
  }

  Widget _buildLunarHeader(CalendarDate info, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFE53935)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.lunarCalendar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (info.lunar != null)
                  Text(
                    '${info.lunar!.yearGanZhi}年 (${info.lunar!.zodiac}年)',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
          if (info.lunar != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    info.lunar!.zodiac,
                    style: const TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  Text(
                    info.lunar!.yearGanZhi,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(AppLocalizations l) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _changeMonth(-1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          l.yearMonth(_currentMonth.year, _currentMonth.month),
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
    final now = DateTime.now();
    final rows = <Widget>[];

    for (int i = 0; i < gridDays.length; i += 7) {
      rows.add(
        Row(
          children: List.generate(7, (j) {
            final date = gridDays[i + j];
            final isCurrentMonth = date.month == _currentMonth.month;
            final isToday = CalendarDateUtils.isSameDay(date, now);
            final isSelected =
                _selectedDate != null &&
                CalendarDateUtils.isSameDay(date, _selectedDate!);
            final calendarDate = CalendarDate.fromDateTime(date);

            return Expanded(
              child: GestureDetector(
                onTap: isCurrentMonth
                    ? () => setState(() => _selectedDate = date)
                    : null,
                child: _ChineseDayCell(
                  calendarDate: calendarDate,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  isSelected: isSelected,
                ),
              ),
            );
          }),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildSelectedDateInfo(AppLocalizations l) {
    final calDate = CalendarDate.fromDateTime(_selectedDate!);
    final lunar = calDate.lunar;
    if (lunar == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l.yearMonthDay(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoChip(l.lunarLabel2, lunar.fullChinese),
              _infoChip(
                l.ganZhi,
                '${lunar.yearGanZhi}${l.yearSuffix} ${lunar.monthGanZhi}${l.monthSuffix} ${lunar.dayGanZhi}${l.daySuffix}',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoChip(l.zodiac, lunar.zodiac),
              if (calDate.solarTerm != null)
                _infoChip(l.solarTerm, calDate.solarTerm!),
              if (calDate.lunarFestival != null)
                _infoChip(l.festival, calDate.lunarFestival!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD32F2F),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChineseDayCell extends StatelessWidget {
  final CalendarDate calendarDate;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;

  const _ChineseDayCell({
    required this.calendarDate,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final lunar = calendarDate.lunar;
    final lunarText = LunarUtils.getLunarDayText(calendarDate.gregorian);
    final isSpecial =
        calendarDate.solarTerm != null || calendarDate.lunarFestival != null;

    return Container(
      height: 56,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFD32F2F).withValues(alpha: 0.12)
            : isToday
            ? const Color(0xFFD32F2F).withValues(alpha: 0.06)
            : null,
        borderRadius: BorderRadius.circular(6),
        border: isToday
            ? Border.all(color: const Color(0xFFD32F2F), width: 1.5)
            : isSelected
            ? Border.all(color: const Color(0xFFD32F2F), width: 1)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${calendarDate.gregorian.day}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isCurrentMonth
                  ? (isToday
                        ? const Color(0xFFD32F2F)
                        : calendarDate.isWeekend
                        ? Colors.red.shade300
                        : Colors.black87)
                  : Colors.grey.shade300,
            ),
          ),
          if (isCurrentMonth && lunar != null)
            Text(
              lunarText,
              style: TextStyle(
                fontSize: 9,
                color: isSpecial
                    ? const Color(0xFFD32F2F)
                    : Colors.grey.shade500,
                fontWeight: isSpecial ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
