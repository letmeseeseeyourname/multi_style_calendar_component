/// 连续打卡计算逻辑
class StreakCounter {
  /// 已完成的日期集合（只存日期部分）
  final Set<DateTime> completedDates;

  StreakCounter({required Iterable<DateTime> completedDates})
    : completedDates = completedDates
          .map((d) => DateTime(d.year, d.month, d.day))
          .toSet();

  /// 当前连续天数（从今天往回数）
  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    int streak = 0;
    var date = DateTime.now();
    date = DateTime(date.year, date.month, date.day);

    // If today is not completed, start from yesterday
    if (!completedDates.contains(date)) {
      date = date.subtract(const Duration(days: 1));
    }

    while (completedDates.contains(date)) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// 最长连续天数
  int get longestStreak {
    if (completedDates.isEmpty) return 0;

    final sorted = completedDates.toList()..sort();
    int longest = 1;
    int current = 1;

    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else if (diff > 1) {
        current = 1;
      }
    }

    return longest;
  }

  /// 本月完成天数
  int completedInMonth(int year, int month) {
    return completedDates
        .where((d) => d.year == year && d.month == month)
        .length;
  }

  /// 本月总天数（到今天为止）
  int totalDaysInMonth(int year, int month) {
    final now = DateTime.now();
    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (year == now.year && month == now.month) {
      return now.day;
    }
    return daysInMonth;
  }

  /// 本月完成率
  double completionRateInMonth(int year, int month) {
    final total = totalDaysInMonth(year, month);
    if (total == 0) return 0.0;
    return completedInMonth(year, month) / total;
  }

  /// 某日是否已完成
  bool isCompleted(DateTime date) {
    return completedDates.contains(DateTime(date.year, date.month, date.day));
  }

  /// 总完成天数
  int get totalCompleted => completedDates.length;

  /// 生成模拟打卡数据
  static StreakCounter createMockData() {
    final now = DateTime.now();
    final dates = <DateTime>[];

    // Generate semi-random completion dates for the past 90 days
    for (int i = 0; i < 90; i++) {
      final date = now.subtract(Duration(days: i));
      // Use a deterministic pattern: skip some days to make streaks interesting
      final hash = (date.day * 7 + date.month * 13 + date.year) % 10;
      if (hash < 7) {
        // ~70% completion rate
        dates.add(date);
      }
    }

    // Ensure recent days have a streak
    for (int i = 0; i < 5; i++) {
      final date = now.subtract(Duration(days: i));
      final dateOnly = DateTime(date.year, date.month, date.day);
      if (!dates.any(
        (d) =>
            d.year == dateOnly.year &&
            d.month == dateOnly.month &&
            d.day == dateOnly.day,
      )) {
        dates.add(dateOnly);
      }
    }

    return StreakCounter(completedDates: dates);
  }
}
