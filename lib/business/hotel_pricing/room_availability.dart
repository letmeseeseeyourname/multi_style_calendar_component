import 'package:flutter/material.dart';

/// 房间类型
class RoomType {
  final String name;
  final String description;
  final double basePrice;
  final int totalRooms;
  final int availableRooms;
  final String? imageIcon;

  const RoomType({
    required this.name,
    required this.description,
    required this.basePrice,
    required this.totalRooms,
    required this.availableRooms,
    this.imageIcon,
  });

  bool get isAvailable => availableRooms > 0;
  bool get isLowAvailability => availableRooms > 0 && availableRooms <= 3;
}

/// 价格信息
class PriceInfo {
  final double price;
  final bool isAvailable;
  final int? roomsLeft;
  final PriceLevel priceLevel;

  const PriceInfo({
    required this.price,
    this.isAvailable = true,
    this.roomsLeft,
    this.priceLevel = PriceLevel.normal,
  });
}

enum PriceLevel { low, normal, high, peak }

extension PriceLevelExtension on PriceLevel {
  String get label {
    switch (this) {
      case PriceLevel.low:
        return '特惠';
      case PriceLevel.normal:
        return '平日';
      case PriceLevel.high:
        return '旺季';
      case PriceLevel.peak:
        return '高峰';
    }
  }

  Color get color {
    switch (this) {
      case PriceLevel.low:
        return const Color(0xFF4CAF50);
      case PriceLevel.normal:
        return const Color(0xFF2196F3);
      case PriceLevel.high:
        return const Color(0xFFFF9800);
      case PriceLevel.peak:
        return const Color(0xFFF44336);
    }
  }
}

/// 房间可用性展示组件
class RoomAvailabilityWidget extends StatelessWidget {
  final DateTime date;
  final List<RoomType> rooms;
  final ValueChanged<RoomType>? onRoomSelected;

  const RoomAvailabilityWidget({
    super.key,
    required this.date,
    required this.rooms,
    this.onRoomSelected,
  });

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
            '${date.month}月${date.day}日 房型',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...rooms.map((room) => _RoomCard(
                room: room,
                onTap: room.isAvailable
                    ? () => onRoomSelected?.call(room)
                    : null,
              )),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final RoomType room;
  final VoidCallback? onTap;

  const _RoomCard({required this.room, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: room.isAvailable
              ? Colors.white
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: room.isAvailable
                ? Colors.grey.shade200
                : Colors.grey.shade100,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: room.isAvailable
                    ? const Color(0xFF2196F3).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.hotel,
                color: room.isAvailable
                    ? const Color(0xFF2196F3)
                    : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: room.isAvailable ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    room.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (room.isAvailable)
                    Text(
                      room.isLowAvailability
                          ? '仅剩${room.availableRooms}间'
                          : '剩余${room.availableRooms}间',
                      style: TextStyle(
                        fontSize: 11,
                        color: room.isLowAvailability
                            ? const Color(0xFFF44336)
                            : const Color(0xFF4CAF50),
                        fontWeight: room.isLowAvailability
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  room.isAvailable ? '¥${room.basePrice.toInt()}' : '已满',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: room.isAvailable
                        ? const Color(0xFFFF5722)
                        : Colors.grey,
                  ),
                ),
                if (room.isAvailable)
                  const Text(
                    '/晚',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 生成模拟房间数据
List<RoomType> generateMockRooms() {
  return const [
    RoomType(
      name: '标准大床房',
      description: '1.8m大床 / 25m² / 含早',
      basePrice: 388,
      totalRooms: 20,
      availableRooms: 8,
    ),
    RoomType(
      name: '豪华双床房',
      description: '2×1.2m单人床 / 30m² / 含早',
      basePrice: 458,
      totalRooms: 15,
      availableRooms: 2,
    ),
    RoomType(
      name: '行政套房',
      description: '1.8m大床 / 45m² / 行政酒廊',
      basePrice: 688,
      totalRooms: 8,
      availableRooms: 5,
    ),
    RoomType(
      name: '总统套房',
      description: '2.0m大床 / 80m² / 全景',
      basePrice: 1288,
      totalRooms: 2,
      availableRooms: 0,
    ),
  ];
}
