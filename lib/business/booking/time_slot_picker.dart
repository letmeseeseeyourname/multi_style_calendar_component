import 'package:flutter/material.dart';

/// 时间段状态
enum SlotStatus { available, booked, selected, unavailable }

/// 时间段数据
class BookingSlot {
  final int hour;
  final int minute;
  final SlotStatus status;
  final String? bookedBy;

  const BookingSlot({
    required this.hour,
    this.minute = 0,
    this.status = SlotStatus.available,
    this.bookedBy,
  });

  String get timeText =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String get endTimeText {
    final endMinute = minute + 30;
    final endHour = hour + (endMinute >= 60 ? 1 : 0);
    return '${endHour.toString().padLeft(2, '0')}:${(endMinute % 60).toString().padLeft(2, '0')}';
  }

  String get rangeText => '$timeText - $endTimeText';

  BookingSlot copyWith({SlotStatus? status}) {
    return BookingSlot(
      hour: hour,
      minute: minute,
      status: status ?? this.status,
      bookedBy: bookedBy,
    );
  }
}

/// 时间段选择网格组件
class TimeSlotPicker extends StatefulWidget {
  final DateTime date;
  final List<BookingSlot> slots;
  final ValueChanged<BookingSlot>? onSlotSelected;
  final int startHour;
  final int endHour;

  const TimeSlotPicker({
    super.key,
    required this.date,
    required this.slots,
    this.onSlotSelected,
    this.startHour = 9,
    this.endHour = 18,
  });

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  BookingSlot? _selectedSlot;

  @override
  Widget build(BuildContext context) {
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
            '${widget.date.month}月${widget.date.day}日 可用时间',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildLegend(),
          const SizedBox(height: 12),
          _buildSlotGrid(),
          if (_selectedSlot != null) ...[
            const SizedBox(height: 16),
            _buildSelectedInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _legendDot(const Color(0xFF4CAF50), '可选'),
        const SizedBox(width: 12),
        _legendDot(const Color(0xFF2196F3), '已选'),
        const SizedBox(width: 12),
        _legendDot(Colors.grey.shade400, '已预约'),
        const SizedBox(width: 12),
        _legendDot(Colors.grey.shade200, '不可用'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSlotGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.slots.map((slot) {
        final isSelected = _selectedSlot != null &&
            _selectedSlot!.hour == slot.hour &&
            _selectedSlot!.minute == slot.minute;

        Color bgColor;
        Color textColor;
        bool canTap = false;

        if (isSelected) {
          bgColor = const Color(0xFF2196F3);
          textColor = Colors.white;
        } else {
          switch (slot.status) {
            case SlotStatus.available:
              bgColor = const Color(0xFF4CAF50).withValues(alpha: 0.12);
              textColor = const Color(0xFF2E7D32);
              canTap = true;
              break;
            case SlotStatus.booked:
              bgColor = Colors.grey.shade200;
              textColor = Colors.grey;
              break;
            case SlotStatus.selected:
              bgColor = const Color(0xFF2196F3);
              textColor = Colors.white;
              break;
            case SlotStatus.unavailable:
              bgColor = Colors.grey.shade100;
              textColor = Colors.grey.shade400;
              break;
          }
        }

        return GestureDetector(
          onTap: (canTap || isSelected)
              ? () {
                  setState(() {
                    _selectedSlot = isSelected ? null : slot;
                  });
                  if (!isSelected) {
                    widget.onSlotSelected?.call(slot);
                  }
                }
              : null,
          child: Container(
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: const Color(0xFF1565C0), width: 1.5)
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  slot.timeText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                if (slot.status == SlotStatus.booked && slot.bookedBy != null)
                  Text(
                    slot.bookedBy!,
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2196F3).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Color(0xFF2196F3), size: 20),
          const SizedBox(width: 8),
          Text(
            '已选择: ${_selectedSlot!.rangeText}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Confirm booking action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已预约 ${_selectedSlot!.rangeText}'),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('确认预约', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

/// 生成模拟时间段数据
List<BookingSlot> generateMockSlots({int startHour = 9, int endHour = 18}) {
  final slots = <BookingSlot>[];
  for (int h = startHour; h < endHour; h++) {
    for (int m = 0; m < 60; m += 30) {
      final hash = (h * 31 + m * 7) % 10;
      SlotStatus status;
      String? bookedBy;
      if (hash < 5) {
        status = SlotStatus.available;
      } else if (hash < 8) {
        status = SlotStatus.booked;
        bookedBy = ['张三', '李四', '王五'][hash % 3];
      } else {
        status = SlotStatus.unavailable;
      }
      slots.add(BookingSlot(
        hour: h,
        minute: m,
        status: status,
        bookedBy: bookedBy,
      ));
    }
  }
  return slots;
}
