import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';
import 'milestone_tracker.dart';

/// 倒计时日历组件
class CountdownCalendar extends StatefulWidget {
  const CountdownCalendar({super.key});

  @override
  State<CountdownCalendar> createState() => _CountdownCalendarState();
}

class _CountdownCalendarState extends State<CountdownCalendar> {
  late DateTime _currentMonth;
  late DateTime _targetDate;
  late List<Milestone> _milestones;

  bool _milestonesInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _targetDate = DateTime.now().add(const Duration(days: 30));
    _milestones = [];
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + delta,
        1,
      );
    });
  }

  int get _daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      _targetDate.year,
      _targetDate.month,
      _targetDate.day,
    );
    return target.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (!_milestonesInitialized) {
      _milestones = generateMockMilestones(l);
      _milestonesInitialized = true;
    }
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Countdown display
          _buildCountdownCard(l),
          const SizedBox(height: 16),
          // Month header
          _buildMonthHeader(l),
          const SizedBox(height: 8),
          // Weekday header
          _buildWeekdayHeader(),
          const SizedBox(height: 4),
          // Calendar grid
          _buildCalendarGrid(gridDays, l),
          const SizedBox(height: 16),
          // Milestones
          MilestoneTracker(milestones: _milestones),
        ],
      ),
    );
  }

  Widget _buildCountdownCard(AppLocalizations l) {
    final days = _daysRemaining;
    final isPast = days < 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPast
              ? [Colors.grey.shade600, Colors.grey.shade500]
              : [const Color(0xFF6A1B9A), const Color(0xFF8E24AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            l.targetCountdown,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildCountdownDigits(days.abs()),
          ),
          const SizedBox(height: 8),
          Text(
            isPast ? l.daysPassed(days.abs()) : l.daysRemaining(days),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.yearMonthDay(
              _targetDate.year,
              _targetDate.month,
              _targetDate.day,
            ),
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 12),
          // Progress bar
          if (!isPast)
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (1 - days / 100).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${((1 - days / 100).clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildCountdownDigits(int days) {
    final digits = days.toString().padLeft(3, '0').split('');
    return digits.map((digit) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 48,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          digit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList();
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

  Widget _buildCalendarGrid(List<DateTime> gridDays, AppLocalizations l) {
    final now = DateTime.now();
    final rows = <Widget>[];

    for (int i = 0; i < gridDays.length; i += 7) {
      rows.add(
        Row(
          children: List.generate(7, (j) {
            final date = gridDays[i + j];
            final isCurrentMonth = date.month == _currentMonth.month;
            final isToday = CalendarDateUtils.isSameDay(date, now);
            final isTarget = CalendarDateUtils.isSameDay(date, _targetDate);
            final hasMilestone = _milestones.any(
              (m) => CalendarDateUtils.isSameDay(m.targetDate, date),
            );

            // Calculate days until target for color gradient
            final daysToTarget = DateTime(
              _targetDate.year,
              _targetDate.month,
              _targetDate.day,
            ).difference(DateTime(date.year, date.month, date.day)).inDays;
            final isBetween =
                isCurrentMonth &&
                !date.isBefore(DateTime(now.year, now.month, now.day)) &&
                daysToTarget >= 0 &&
                daysToTarget <= _daysRemaining;

            return Expanded(
              child: GestureDetector(
                onTap: isCurrentMonth
                    ? () => setState(() => _targetDate = date)
                    : null,
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isTarget
                        ? const Color(0xFF6A1B9A)
                        : isBetween
                        ? Color.lerp(
                            const Color(0xFF6A1B9A).withValues(alpha: 0.05),
                            const Color(0xFF6A1B9A).withValues(alpha: 0.2),
                            daysToTarget > 0
                                ? (1 - daysToTarget / max(_daysRemaining, 1))
                                : 1.0,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(6),
                    border: isToday
                        ? Border.all(color: const Color(0xFF6A1B9A), width: 1.5)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: (isToday || isTarget)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isTarget
                                  ? Colors.white
                                  : !isCurrentMonth
                                  ? Colors.grey.shade300
                                  : Colors.black87,
                            ),
                          ),
                          if (isTarget)
                            Text(
                              l.target,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      ),
                      if (hasMilestone && !isTarget)
                        Positioned(
                          bottom: 2,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF5722),
                              shape: BoxShape.circle,
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
