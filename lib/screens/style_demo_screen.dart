import 'package:flutter/material.dart';
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
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('视觉风格'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '经典网格'),
              Tab(text: '卡片式'),
              Tab(text: '圆形'),
              Tab(text: '热力图'),
              Tab(text: '翻页'),
              Tab(text: '极简'),
              Tab(text: '毛玻璃'),
              Tab(text: '更多'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ClassicGridCalendar(),
            const CardCalendar(),
            _buildCircularTab(),
            _buildHeatmapTab(),
            const FlipCalendar(),
            const MinimalCalendar(),
            const GlassCalendar(),
            _buildMoreStylesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('圆形周视图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const SizedBox(height: 350, child: CircularWeekView()),
        const SizedBox(height: 24),
        const Text('环形月视图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const SizedBox(height: 350, child: RingMonthView()),
        const SizedBox(height: 24),
        const Text('时钟式日视图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(height: 350, child: ClockDayView(date: DateTime.now())),
      ],
    );
  }

  Widget _buildHeatmapTab() {
    final now = DateTime.now();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('GitHub 风格热力图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(height: 200, child: GitHubHeatmap(year: now.year, data: const {})),
        const SizedBox(height: 24),
        const Text('活动热力图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildMoreStylesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('环形月视图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const SizedBox(height: 350, child: RingMonthView()),
        const SizedBox(height: 24),
        const Text('时钟日视图', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(height: 350, child: ClockDayView(date: DateTime.now())),
      ],
    );
  }
}
