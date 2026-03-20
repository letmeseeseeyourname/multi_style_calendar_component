import 'package:flutter/material.dart';

/// 日历文字样式
class CalendarTextStyles {
  CalendarTextStyles._();

  static const TextStyle dayNumber = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle todayNumber = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle lunarText = TextStyle(
    fontSize: 10,
    color: Color(0xFF757575),
  );

  static const TextStyle solarTermText = TextStyle(
    fontSize: 10,
    color: Color(0xFFE91E63),
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headerTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle weekdayLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF757575),
  );

  static const TextStyle eventTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle priceText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );
}
