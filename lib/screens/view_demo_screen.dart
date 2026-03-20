import 'package:flutter/material.dart';
import '../views/month_view/month_view.dart';
import '../views/week_view/week_view.dart';
import '../views/day_view/day_view.dart';
import '../views/year_view/year_view.dart';
import '../views/agenda_view/agenda_view.dart';
import '../views/timeline_view/timeline_view.dart';
import '../views/scroll_picker/scroll_date_picker.dart';

/// 视图模式演示
class ViewDemoScreen extends StatelessWidget {
  const ViewDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('视图模式'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '月视图'),
              Tab(text: '周视图'),
              Tab(text: '日视图'),
              Tab(text: '年视图'),
              Tab(text: '日程列表'),
              Tab(text: '时间线'),
              Tab(text: '滚动选择'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const MonthView(),
            WeekView(weekStart: _getWeekStart()),
            DayView(date: DateTime.now()),
            YearView(year: DateTime.now().year),
            AgendaView(
              events: const [],
              startDate: DateTime.now(),
            ),
            TimelineView(
              events: const [],
              startDate: DateTime.now().subtract(const Duration(days: 15)),
              endDate: DateTime.now().add(const Duration(days: 15)),
            ),
            ScrollDatePicker(initialDate: DateTime.now()),
          ],
        ),
      ),
    );
  }

  static DateTime _getWeekStart() {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }
}
