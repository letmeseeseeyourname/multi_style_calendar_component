import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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
    final l = AppLocalizations.of(context);

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.businessScenarios),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l.attendance),
              Tab(text: l.habitTracker),
              Tab(text: l.booking),
              Tab(text: l.hotelPricing),
              Tab(text: l.lunarCalendar),
              Tab(text: l.countdown),
              Tab(text: l.sharedCalendar),
              Tab(text: l.periodTracker),
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
