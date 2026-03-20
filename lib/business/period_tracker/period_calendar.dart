import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import 'cycle_predictor.dart';
import 'symptom_logger.dart';

/// 经期追踪日历组件
class PeriodCalendar extends StatefulWidget {
  const PeriodCalendar({super.key});

  @override
  State<PeriodCalendar> createState() => _PeriodCalendarState();
}

class _PeriodCalendarState extends State<PeriodCalendar> {
  late DateTime _currentMonth;
  late CyclePredictor _predictor;
  DateTime? _selectedDate;
  final Map<String, List<SymptomEntry>> _symptomLogs = {};

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _predictor = CyclePredictor.createMockPredictor();
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + delta, 1);
      _selectedDate = null;
    });
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return SingleChildScrollView(
      child: Column(
      children: [
        // Cycle info card
        _buildCycleInfo(),
        const SizedBox(height: 16),
        // Month header
        _buildMonthHeader(),
        const SizedBox(height: 8),
        // Weekday header
        _buildWeekdayHeader(),
        const SizedBox(height: 4),
        // Calendar grid
        _buildCalendarGrid(gridDays),
        const SizedBox(height: 12),
        // Legend
        _buildLegend(),
        // Symptom logger for selected date
        if (_selectedDate != null) ...[
          const SizedBox(height: 16),
          SymptomLogger(
            date: _selectedDate!,
            initialSymptoms: _symptomLogs[_dateKey(_selectedDate!)] ?? [],
            onSymptomsChanged: (symptoms) {
              _symptomLogs[_dateKey(_selectedDate!)] = symptoms;
            },
          ),
        ],
      ],
    ),
    );
  }

  Widget _buildCycleInfo() {
    final avgCycle = _predictor.averageCycleLength;
    final nextPeriod = _predictor.nextPeriodStart;
    final daysUntil = nextPeriod != null
        ? nextPeriod.difference(DateTime.now()).inDays
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFFF5252)],
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
                const Text(
                  '经期追踪',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  daysUntil != null && daysUntil > 0
                      ? '距下次经期还有 $daysUntil 天'
                      : daysUntil == 0
                          ? '预计今天开始'
                          : '经期进行中',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  '平均周期',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                Text(
                  '$avgCycle天',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
          '${_currentMonth.year}年${_currentMonth.month}月',
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
    final rows = <Widget>[];
    for (int i = 0; i < gridDays.length; i += 7) {
      rows.add(
        Row(
          children: List.generate(7, (j) {
            final date = gridDays[i + j];
            final isCurrentMonth = date.month == _currentMonth.month;
            final isSelected = _selectedDate != null &&
                CalendarDateUtils.isSameDay(date, _selectedDate!);

            return Expanded(
              child: GestureDetector(
                onTap: isCurrentMonth
                    ? () => setState(() => _selectedDate = date)
                    : null,
                child: _PeriodDayCell(
                  date: date,
                  predictor: _predictor,
                  isCurrentMonth: isCurrentMonth,
                  isSelected: isSelected,
                  isToday: CalendarDateUtils.isSameDay(date, DateTime.now()),
                  hasSymptoms:
                      (_symptomLogs[_dateKey(date)]?.isNotEmpty ?? false),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(const Color(0xFFE91E63), '经期'),
        const SizedBox(width: 16),
        _legendItem(const Color(0xFFFF8A80), '预测经期'),
        const SizedBox(width: 16),
        _legendItem(const Color(0xFF81C784), '易孕期'),
        const SizedBox(width: 16),
        _legendItem(const Color(0xFF4CAF50), '排卵日'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _PeriodDayCell extends StatelessWidget {
  final DateTime date;
  final CyclePredictor predictor;
  final bool isCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool hasSymptoms;

  const _PeriodDayCell({
    required this.date,
    required this.predictor,
    required this.isCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.hasSymptoms,
  });

  @override
  Widget build(BuildContext context) {
    final isPeriod = predictor.isPeriodDay(date);
    final isPredicted = predictor.isPredictedPeriodDay(date);
    final isFertile = predictor.isFertileDay(date);
    final isOvulation = predictor.isOvulationDay(date);

    Color? bgColor;
    if (isPeriod) {
      bgColor = const Color(0xFFE91E63).withValues(alpha: 0.2);
    } else if (isPredicted) {
      bgColor = const Color(0xFFFF8A80).withValues(alpha: 0.2);
    } else if (isOvulation) {
      bgColor = const Color(0xFF4CAF50).withValues(alpha: 0.2);
    } else if (isFertile) {
      bgColor = const Color(0xFF81C784).withValues(alpha: 0.15);
    }

    return Container(
      height: 48,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFE91E63).withValues(alpha: 0.15)
            : bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: const Color(0xFFE91E63), width: 1.5)
            : isSelected
                ? Border.all(color: const Color(0xFFE91E63), width: 1)
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
                  ? (isPeriod
                      ? const Color(0xFFE91E63)
                      : isToday
                          ? const Color(0xFFE91E63)
                          : Colors.black87)
                  : Colors.grey.shade300,
            ),
          ),
          if (isCurrentMonth && (isPeriod || isOvulation || hasSymptoms))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isPeriod)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 2, right: 1),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE91E63),
                      shape: BoxShape.circle,
                    ),
                  ),
                if (isOvulation)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 2, right: 1),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                if (hasSymptoms)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF9800),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
