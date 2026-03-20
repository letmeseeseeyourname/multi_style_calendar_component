import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';
import 'room_availability.dart';

/// 酒店价格日历组件
class PriceCalendar extends StatefulWidget {
  const PriceCalendar({super.key});

  @override
  State<PriceCalendar> createState() => _PriceCalendarState();
}

class _PriceCalendarState extends State<PriceCalendar> {
  late DateTime _currentMonth;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  bool _isSelectingCheckOut = false;
  late Map<String, PriceInfo> _prices;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _prices = _generateMockPrices();
  }

  Map<String, PriceInfo> _generateMockPrices() {
    final prices = <String, PriceInfo>{};
    final daysInMonth =
        CalendarDateUtils.daysInMonth(_currentMonth.year, _currentMonth.month);
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, d);
      final isWeekend = date.weekday == 6 || date.weekday == 7;
      final hash = (d * 17 + _currentMonth.month * 3) % 20;

      double basePrice = 388;
      PriceLevel level;
      int roomsLeft;

      if (isWeekend) {
        basePrice = 488 + (hash * 10).toDouble();
        level = PriceLevel.high;
        roomsLeft = 2 + hash % 4;
      } else if (hash < 3) {
        basePrice = 288 + (hash * 15).toDouble();
        level = PriceLevel.low;
        roomsLeft = 10 + hash;
      } else if (hash > 15) {
        basePrice = 588 + (hash * 8).toDouble();
        level = PriceLevel.peak;
        roomsLeft = hash % 3;
      } else {
        basePrice = 388 + (hash * 5).toDouble();
        level = PriceLevel.normal;
        roomsLeft = 5 + hash % 8;
      }

      final key = '$d';
      prices[key] = PriceInfo(
        price: basePrice,
        isAvailable: roomsLeft > 0,
        roomsLeft: roomsLeft,
        priceLevel: level,
      );
    }
    return prices;
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth =
          DateTime(_currentMonth.year, _currentMonth.month + delta, 1);
      _prices = _generateMockPrices();
    });
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (!_isSelectingCheckOut || _checkInDate == null) {
        _checkInDate = date;
        _checkOutDate = null;
        _isSelectingCheckOut = true;
      } else {
        if (date.isAfter(_checkInDate!)) {
          _checkOutDate = date;
          _isSelectingCheckOut = false;
        } else {
          _checkInDate = date;
          _checkOutDate = null;
        }
      }
    });
  }

  bool _isInRange(DateTime date) {
    if (_checkInDate == null || _checkOutDate == null) return false;
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(
        _checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
    final e = DateTime(
        _checkOutDate!.year, _checkOutDate!.month, _checkOutDate!.day);
    return d.isAfter(s) && d.isBefore(e);
  }

  double get _totalPrice {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    double total = 0;
    var current = _checkInDate!;
    while (current.isBefore(_checkOutDate!)) {
      final info = _prices['${current.day}'];
      if (info != null) total += info.price;
      current = current.add(const Duration(days: 1));
    }
    return total;
  }

  int get _nightCount {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    return _checkOutDate!.difference(_checkInDate!).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final gridDays = CalendarDateUtils.daysInMonthGrid(_currentMonth);

    return SingleChildScrollView(
      child: Column(
      children: [
        // Month header
        _buildMonthHeader(l),
        const SizedBox(height: 4),
        // Legend
        _buildLegend(l),
        const SizedBox(height: 8),
        // Weekday header
        _buildWeekdayHeader(),
        const SizedBox(height: 4),
        // Calendar grid
        _buildCalendarGrid(gridDays, l),
        // Price summary
        if (_checkInDate != null) ...[
          const SizedBox(height: 16),
          _buildPriceSummary(l),
        ],
        // Room availability
        if (_checkInDate != null) ...[
          const SizedBox(height: 16),
          RoomAvailabilityWidget(
            date: _checkInDate!,
            rooms: generateMockRooms(l),
          ),
        ],
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
        Column(
          children: [
            Text(
              l.yearMonth(_currentMonth.year, _currentMonth.month),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _isSelectingCheckOut ? l.selectCheckOutDate : l.selectCheckInDate,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          onPressed: () => _changeMonth(1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildLegend(AppLocalizations l) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: PriceLevel.values.map((level) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: level.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                level.localizedLabel(l),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
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
            final isPast =
                date.isBefore(DateTime(now.year, now.month, now.day));
            final priceInfo = isCurrentMonth ? _prices['${date.day}'] : null;
            final isAvailable = priceInfo?.isAvailable ?? false;

            final isCheckIn = _checkInDate != null &&
                CalendarDateUtils.isSameDay(date, _checkInDate!);
            final isCheckOut = _checkOutDate != null &&
                CalendarDateUtils.isSameDay(date, _checkOutDate!);
            final inRange = _isInRange(date);
            final isToday = CalendarDateUtils.isSameDay(date, now);

            return Expanded(
              child: GestureDetector(
                onTap: (isCurrentMonth && !isPast && isAvailable)
                    ? () => _onDateTap(date)
                    : null,
                child: Container(
                  height: 58,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: isCheckIn || isCheckOut
                        ? const Color(0xFF2196F3)
                        : inRange
                            ? const Color(0xFFBBDEFB)
                            : null,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          isCheckIn ? 8 : (inRange ? 0 : 4)),
                      bottomLeft: Radius.circular(
                          isCheckIn ? 8 : (inRange ? 0 : 4)),
                      topRight: Radius.circular(
                          isCheckOut ? 8 : (inRange ? 0 : 4)),
                      bottomRight: Radius.circular(
                          isCheckOut ? 8 : (inRange ? 0 : 4)),
                    ),
                    border: isToday && !isCheckIn && !isCheckOut
                        ? Border.all(
                            color: const Color(0xFF2196F3), width: 1)
                        : null,
                  ),
                  child: Opacity(
                    opacity: (!isCurrentMonth || isPast || !isAvailable)
                        ? 0.35
                        : 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isCheckIn)
                          Text(
                            l.checkInLabel,
                            style: const TextStyle(
                                fontSize: 8, color: Colors.white70),
                          )
                        else if (isCheckOut)
                          Text(
                            l.checkOutLabel,
                            style: const TextStyle(
                                fontSize: 8, color: Colors.white70),
                          ),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: (isCheckIn || isCheckOut)
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: (isCheckIn || isCheckOut)
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        if (priceInfo != null && isCurrentMonth)
                          Text(
                            '¥${priceInfo.price.toInt()}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: (isCheckIn || isCheckOut)
                                  ? Colors.white
                                  : priceInfo.priceLevel.color,
                            ),
                          ),
                        if (priceInfo != null &&
                            priceInfo.roomsLeft != null &&
                            priceInfo.roomsLeft! <= 3 &&
                            priceInfo.isAvailable &&
                            !isCheckIn &&
                            !isCheckOut)
                          Text(
                            l.roomsLeft(priceInfo.roomsLeft!),
                            style: const TextStyle(
                              fontSize: 8,
                              color: Color(0xFFF44336),
                            ),
                          ),
                      ],
                    ),
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

  Widget _buildPriceSummary(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFE0B2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.checkInLabel,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      l.monthDay(_checkInDate!.month, _checkInDate!.day),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_checkOutDate != null) ...[
                const Icon(Icons.arrow_forward, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.checkOutLabel,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        l.monthDay(_checkOutDate!.month, _checkOutDate!.day),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l.nightsTotal(_nightCount),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '¥${_totalPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5722),
                      ),
                    ),
                  ],
                ),
              ] else
                Expanded(
                  child: Text(
                    l.selectCheckOutDate,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
