import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../styles/classic_grid/classic_grid_style.dart';
import '../styles/card_style/card_calendar.dart';
import '../styles/circular/circular_week.dart';
import '../styles/circular/ring_month.dart';
import '../styles/circular/clock_day.dart';
import '../styles/heatmap/github_heatmap.dart';
import '../styles/heatmap/activity_heatmap.dart';
import '../styles/flip_calendar/flip_calendar.dart';
import '../styles/minimal/minimal_calendar.dart';
import '../styles/glassmorphism/glass_calendar.dart';

/// 视觉风格演示
class StyleDemoScreen extends StatelessWidget {
  const StyleDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.visualStyles),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l.classicGrid),
              Tab(text: l.cardStyle),
              Tab(text: l.circular),
              Tab(text: l.heatmap),
              Tab(text: l.flip),
              Tab(text: l.minimal),
              Tab(text: l.glassmorphism),
              Tab(text: l.more),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ClassicGridCalendar(),
            const CardCalendar(),
            _buildCircularTab(context),
            _buildHeatmapTab(context),
            const FlipCalendar(),
            const MinimalCalendar(),
            const GlassCalendar(),
            _buildMoreStylesTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTab(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l.circularWeekView,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 350, child: CircularWeekView()),
        const SizedBox(height: 24),
        Text(
          l.ringMonthView,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 350, child: RingMonthView()),
        const SizedBox(height: 24),
        Text(
          l.clockDayView,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 350, child: ClockDayView(date: DateTime.now())),
      ],
    );
  }

  Widget _buildHeatmapTab(BuildContext context) {
    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l.githubHeatmap,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: GitHubHeatmap(year: now.year, data: const {}),
        ),
        const SizedBox(height: 24),
        Text(
          l.activityHeatmap,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ActivityHeatmap(
            data: const {},
            startDate: DateTime(now.year, 1, 1),
            endDate: DateTime(now.year, 12, 31),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreStylesTab(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l.ringMonthView,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 350, child: RingMonthView()),
        const SizedBox(height: 24),
        Text(
          l.clockDayView,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 350, child: ClockDayView(date: DateTime.now())),
      ],
    );
  }
}
