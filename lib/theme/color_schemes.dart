import 'package:flutter/material.dart';

/// 日历配色系统
class CalendarColors {
  CalendarColors._();

  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);

  static const Color today = Color(0xFF2196F3);
  static const Color selected = Color(0xFF1976D2);
  static const Color inRange = Color(0xFFBBDEFB);
  static const Color weekend = Color(0xFFEF5350);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color holiday = Color(0xFFE91E63);

  static const List<Color> eventColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFF795548),
    Color(0xFF607D8B),
  ];

  static Color heatmapColor(double intensity, Color base) {
    return Color.lerp(
      base.withValues(alpha: 0.1),
      base,
      intensity,
    )!;
  }
}
