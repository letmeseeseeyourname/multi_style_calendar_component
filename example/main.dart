import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar_collection/flutter_calendar_collection.dart';

void main() {
  runApp(const ProviderScope(child: ExampleApp()));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Example',
      theme: AppTheme.lightTheme,
      home: const CalendarExample(),
    );
  }
}

class CalendarExample extends StatefulWidget {
  const CalendarExample({super.key});

  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Example')),
      body: Column(
        children: [
          // Navigation header
          CalendarHeader(
            currentDate: _currentMonth,
            title:
                '${_currentMonth.year}-${_currentMonth.month.toString().padLeft(2, '0')}',
            onPrevious: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                );
              });
            },
            onNext: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                );
              });
            },
            onToday: () {
              setState(() {
                _currentMonth = DateTime.now();
              });
            },
          ),
          // Week header
          const WeekHeader(),
          // Month grid
          Expanded(
            child: MonthGrid(
              month: _currentMonth,
              selectedDate: _selectedDate,
              config: const CalendarConfig(showLunar: true),
              onDateTap: (date) {
                setState(() => _selectedDate = date);
              },
            ),
          ),
        ],
      ),
    );
  }
}
