import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';
import 'member_colors.dart';
import 'conflict_detector.dart';

/// 多用户共享日历组件
class SharedCalendar extends StatefulWidget {
  const SharedCalendar({super.key});

  @override
  State<SharedCalendar> createState() => _SharedCalendarState();
}

class _SharedCalendarState extends State<SharedCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;
  late List<CalendarMember> _members;
  late List<SharedEvent> _events;
  final Set<String> _visibleMemberIds = {};

  bool _dataInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _members = [];
    _events = [];
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

  CalendarMember? _getMember(String id) {
    try {
      return _members.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<SharedEvent> _getEventsOnDate(DateTime date) {
    return _events.where((e) {
      if (!e.occursOn(date)) return false;
      // Filter by visible members
      return e.allMemberIds.any((id) => _visibleMemberIds.contains(id));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (!_dataInitialized) {
      _members = generateMockMembers();
      _events = generateMockSharedEvents(l);
      _visibleMemberIds.addAll(_members.map((m) => m.id));
      _dataInitialized = true;
    }
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Member filter
          _buildMemberFilter(l),
          const SizedBox(height: 12),
          // Month header
          _buildMonthHeader(l),
          const SizedBox(height: 8),
          // Weekday header
          _buildWeekdayHeader(),
          const SizedBox(height: 4),
          // Calendar grid
          _buildCalendarGrid(gridDays),
          // Selected date events
          if (_selectedDate != null) ...[
            const SizedBox(height: 16),
            _buildDayEvents(l),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberFilter(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, size: 18, color: Color(0xFF2196F3)),
              const SizedBox(width: 6),
              Text(
                l.memberCalendar,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _members.map((member) {
              final isVisible = _visibleMemberIds.contains(member.id);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isVisible) {
                      _visibleMemberIds.remove(member.id);
                    } else {
                      _visibleMemberIds.add(member.id);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isVisible
                        ? member.color.withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isVisible ? member.color : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isVisible ? member.color : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        member.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: isVisible ? Colors.black87 : Colors.grey,
                          fontWeight: isVisible
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
            final isSelected =
                _selectedDate != null &&
                CalendarDateUtils.isSameDay(date, _selectedDate!);
            final dayEvents = isCurrentMonth
                ? _getEventsOnDate(date)
                : <SharedEvent>[];
            final hasConflicts =
                dayEvents.length > 1 &&
                ConflictDetector.findConflictsOnDate(_events, date).isNotEmpty;

            // Collect member colors for event dots
            final memberColorSet = <Color>{};
            for (final event in dayEvents) {
              final creator = _getMember(event.creatorId);
              if (creator != null && _visibleMemberIds.contains(creator.id)) {
                memberColorSet.add(creator.color);
              }
            }

            return Expanded(
              child: GestureDetector(
                onTap: isCurrentMonth
                    ? () => setState(() => _selectedDate = date)
                    : null,
                child: Container(
                  height: 52,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2196F3).withValues(alpha: 0.12)
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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrentMonth
                                  ? (isToday
                                        ? const Color(0xFF2196F3)
                                        : Colors.black87)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          if (hasConflicts && isCurrentMonth)
                            Positioned(
                              top: -2,
                              right: -8,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF44336),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (memberColorSet.isNotEmpty && isCurrentMonth)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: memberColorSet
                                .take(4)
                                .map(
                                  (color) => Container(
                                    width: 5,
                                    height: 5,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                                .toList(),
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

  Widget _buildDayEvents(AppLocalizations l) {
    final dayEvents = _getEventsOnDate(_selectedDate!);
    final conflicts = ConflictDetector.findConflictsOnDate(
      _events,
      _selectedDate!,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.daySchedule(_selectedDate!.month, _selectedDate!.day),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (conflicts.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF44336).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFF44336).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Color(0xFFF44336),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: conflicts.map((c) {
                        final memberNames = c.conflictingMemberIds
                            .map((id) => _getMember(id)?.name ?? id)
                            .join(', ');
                        return Text(
                          l.conflictText(
                            c.eventA.title,
                            c.eventB.title,
                            c.localizedOverlapText(l),
                            memberNames,
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFF44336),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (dayEvents.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l.noEvents,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...dayEvents.map((event) {
              final creator = _getMember(event.creatorId);
              final isConflicting = ConflictDetector.hasConflict(
                event,
                dayEvents,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (creator?.color ?? Colors.grey).withValues(
                    alpha: 0.08,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: creator?.color ?? Colors.grey,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isConflicting)
                          const Icon(
                            Icons.warning_amber,
                            color: Color(0xFFF44336),
                            size: 16,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.timeText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (event.location != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.location_on,
                            size: 13,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            event.location!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Attendee avatars
                    Row(
                      children: [
                        Text(
                          l.attendees,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        ...event.allMemberIds.map((id) {
                          final member = _getMember(id);
                          if (member == null) return const SizedBox.shrink();
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: member.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              member.name,
                              style: TextStyle(
                                fontSize: 10,
                                color: member.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
