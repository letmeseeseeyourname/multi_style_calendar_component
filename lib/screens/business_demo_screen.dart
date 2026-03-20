import 'package:flutter/material.dart';
import '../business/attendance/attendance_calendar.dart';
import '../business/habit_tracker/habit_calendar.dart';
import '../business/booking/booking_calendar.dart';
import '../business/hotel_pricing/price_calendar.dart';
import '../business/lunar_calendar/chinese_calendar.dart';
import '../business/countdown/countdown_calendar.dart';
import '../business/shared_calendar/shared_calendar.dart';
import '../business/period_tracker/period_calendar.dart';

/// 业务场景演示
class BusinessDemoScreen extends StatelessWidget {
  const BusinessDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('业务场景'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '考勤'),
              Tab(text: '习惯追踪'),
              Tab(text: '预约'),
              Tab(text: '酒店价格'),
              Tab(text: '农历'),
              Tab(text: '倒计时'),
              Tab(text: '共享日历'),
              Tab(text: '经期追踪'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AttendanceCalendar(),
            HabitCalendar(),
            BookingCalendar(),
            PriceCalendar(),
            ChineseCalendar(),
            CountdownCalendar(),
            SharedCalendar(),
            PeriodCalendar(),
          ],
        ),
      ),
    );
  }
}
