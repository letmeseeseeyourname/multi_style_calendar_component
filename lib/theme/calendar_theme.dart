import 'package:flutter/material.dart';

/// 日历主题数据
class CalendarThemeData {
  final Color primaryColor;
  final Color todayColor;
  final Color selectedColor;
  final Color rangeColor;
  final Color weekendColor;
  final Color disabledColor;
  final Color holidayColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color headerColor;
  final TextStyle dayTextStyle;
  final TextStyle lunarTextStyle;
  final TextStyle headerTextStyle;
  final TextStyle weekdayTextStyle;
  final double cellRadius;
  final double cellPadding;

  const CalendarThemeData({
    this.primaryColor = const Color(0xFF2196F3),
    this.todayColor = const Color(0xFF2196F3),
    this.selectedColor = const Color(0xFF1976D2),
    this.rangeColor = const Color(0xFFBBDEFB),
    this.weekendColor = const Color(0xFFEF5350),
    this.disabledColor = const Color(0xFFBDBDBD),
    this.holidayColor = const Color(0xFFE91E63),
    this.backgroundColor = Colors.white,
    this.surfaceColor = const Color(0xFFF5F5F5),
    this.headerColor = const Color(0xFF212121),
    this.dayTextStyle = const TextStyle(fontSize: 16),
    this.lunarTextStyle = const TextStyle(
      fontSize: 10,
      color: Color(0xFF757575),
    ),
    this.headerTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF212121),
    ),
    this.weekdayTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFF757575),
    ),
    this.cellRadius = 8,
    this.cellPadding = 4,
  });

  CalendarThemeData copyWith({
    Color? primaryColor,
    Color? todayColor,
    Color? selectedColor,
    Color? backgroundColor,
  }) {
    return CalendarThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      todayColor: todayColor ?? this.todayColor,
      selectedColor: selectedColor ?? this.selectedColor,
      rangeColor: rangeColor,
      weekendColor: weekendColor,
      disabledColor: disabledColor,
      holidayColor: holidayColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor,
      headerColor: headerColor,
      dayTextStyle: dayTextStyle,
      lunarTextStyle: lunarTextStyle,
      headerTextStyle: headerTextStyle,
      weekdayTextStyle: weekdayTextStyle,
      cellRadius: cellRadius,
      cellPadding: cellPadding,
    );
  }
}

class CalendarTheme extends InheritedWidget {
  final CalendarThemeData data;

  const CalendarTheme({super.key, required this.data, required super.child});

  static CalendarThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<CalendarTheme>();
    return theme?.data ?? const CalendarThemeData();
  }

  @override
  bool updateShouldNotify(CalendarTheme oldWidget) => data != oldWidget.data;
}
