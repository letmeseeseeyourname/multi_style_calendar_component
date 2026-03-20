import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';

/// 周可用性网格组件 - 展示一周内每天各时段的预约情况
class AvailabilityGrid extends StatelessWidget {
  final DateTime weekStart;
  final Map<String, bool> availability; // "day-hour" -> available
  final ValueChanged<(DateTime, int)>? onSlotTap;

  const AvailabilityGrid({
    super.key,
    required this.weekStart,
    required this.availability,
    this.onSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(10, (i) => i + 8); // 8:00 - 17:00

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
          const Text(
            '本周可用时间',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _legendDot(const Color(0xFF4CAF50).withValues(alpha: 0.3), '可用'),
              const SizedBox(width: 12),
              _legendDot(const Color(0xFFF44336).withValues(alpha: 0.3), '已约'),
              const SizedBox(width: 12),
              _legendDot(Colors.grey.shade200, '不可用'),
            ],
          ),
          const SizedBox(height: 12),
          // Grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                // Header row with day names
                Row(
                  children: [
                    const SizedBox(width: 50), // time column
                    ...List.generate(7, (i) {
                      final date = weekStart.add(Duration(days: i));
                      final isToday =
                          CalendarDateUtils.isSameDay(date, DateTime.now());
                      return Container(
                        width: 56,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            Text(
                              CalendarDateUtils.weekdayName(date.weekday),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isToday
                                    ? const Color(0xFF2196F3)
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isToday
                                    ? const Color(0xFF2196F3)
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                // Time rows
                ...hours.map((hour) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${hour.toString().padLeft(2, '0')}:00',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ...List.generate(7, (dayIndex) {
                        final date = weekStart.add(Duration(days: dayIndex));
                        final key = '${dayIndex}-$hour';
                        final isAvailable = availability[key] ?? false;
                        final isWeekend =
                            date.weekday == 6 || date.weekday == 7;

                        Color cellColor;
                        if (isWeekend) {
                          cellColor = Colors.grey.shade100;
                        } else if (isAvailable) {
                          cellColor =
                              const Color(0xFF4CAF50).withValues(alpha: 0.2);
                        } else {
                          cellColor =
                              const Color(0xFFF44336).withValues(alpha: 0.15);
                        }

                        return GestureDetector(
                          onTap: (isAvailable && !isWeekend)
                              ? () => onSlotTap?.call((date, hour))
                              : null,
                          child: Container(
                            width: 56,
                            height: 32,
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: isAvailable && !isWeekend
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Color(0xFF4CAF50),
                                  )
                                : null,
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

/// 生成模拟周可用性数据
Map<String, bool> generateMockAvailability() {
  final data = <String, bool>{};
  for (int day = 0; day < 7; day++) {
    for (int hour = 8; hour < 18; hour++) {
      final key = '$day-$hour';
      // Weekends are not available
      if (day >= 5) {
        data[key] = false;
      } else {
        final hash = (day * 17 + hour * 7) % 10;
        data[key] = hash < 6; // ~60% available
      }
    }
  }
  return data;
}
