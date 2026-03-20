/// 经期预测逻辑类
class CyclePredictor {
  /// 周期记录：每次经期开始日期
  final List<DateTime> periodStartDates;

  /// 默认周期天数
  final int defaultCycleLength;

  /// 默认经期持续天数
  final int defaultPeriodLength;

  CyclePredictor({
    required this.periodStartDates,
    this.defaultCycleLength = 28,
    this.defaultPeriodLength = 5,
  });

  /// 计算平均周期长度
  int get averageCycleLength {
    if (periodStartDates.length < 2) return defaultCycleLength;

    final sorted = List<DateTime>.from(periodStartDates)..sort();
    int totalDays = 0;
    int count = 0;

    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff > 15 && diff < 60) {
        totalDays += diff;
        count++;
      }
    }

    return count > 0 ? (totalDays / count).round() : defaultCycleLength;
  }

  /// 计算平均经期持续天数
  int get averagePeriodLength => defaultPeriodLength;

  /// 预测下次经期开始日期
  DateTime? get nextPeriodStart {
    if (periodStartDates.isEmpty) return null;
    final sorted = List<DateTime>.from(periodStartDates)..sort();
    final lastStart = sorted.last;
    return lastStart.add(Duration(days: averageCycleLength));
  }

  /// 预测下次经期结束日期
  DateTime? get nextPeriodEnd {
    final start = nextPeriodStart;
    if (start == null) return null;
    return start.add(Duration(days: averagePeriodLength - 1));
  }

  /// 预测排卵日（周期第14天左右）
  DateTime? get nextOvulationDate {
    final start = nextPeriodStart;
    if (start == null) return null;
    // Ovulation typically occurs 14 days before next period
    return start.subtract(const Duration(days: 14));
  }

  /// 获取易孕窗口（排卵日前5天到排卵日后1天）
  (DateTime start, DateTime end)? get fertileWindow {
    final ovulation = nextOvulationDate;
    if (ovulation == null) return null;
    return (
      ovulation.subtract(const Duration(days: 5)),
      ovulation.add(const Duration(days: 1)),
    );
  }

  /// 判断某天是否在经期中
  bool isPeriodDay(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final sorted = List<DateTime>.from(periodStartDates)..sort();

    for (final start in sorted) {
      final startOnly = DateTime(start.year, start.month, start.day);
      final endOnly = startOnly.add(Duration(days: averagePeriodLength - 1));
      if (!dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly)) {
        return true;
      }
    }
    return false;
  }

  /// 判断某天是否在预测经期中
  bool isPredictedPeriodDay(DateTime date) {
    final next = nextPeriodStart;
    if (next == null) return false;
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(next.year, next.month, next.day);
    final endOnly = startOnly.add(Duration(days: averagePeriodLength - 1));
    return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
  }

  /// 判断某天是否在易孕窗口
  bool isFertileDay(DateTime date) {
    final window = fertileWindow;
    if (window == null) return false;
    final dateOnly = DateTime(date.year, date.month, date.day);
    final start = DateTime(window.$1.year, window.$1.month, window.$1.day);
    final end = DateTime(window.$2.year, window.$2.month, window.$2.day);
    return !dateOnly.isBefore(start) && !dateOnly.isAfter(end);
  }

  /// 判断某天是否是排卵日
  bool isOvulationDay(DateTime date) {
    final ovulation = nextOvulationDate;
    if (ovulation == null) return false;
    return date.year == ovulation.year &&
        date.month == ovulation.month &&
        date.day == ovulation.day;
  }

  /// 生成模拟周期数据
  static CyclePredictor createMockPredictor() {
    final now = DateTime.now();
    return CyclePredictor(
      periodStartDates: [
        DateTime(now.year, now.month - 3, 5),
        DateTime(now.year, now.month - 2, 3),
        DateTime(now.year, now.month - 1, 1),
        DateTime(now.year, now.month, now.day - 10),
      ],
      defaultCycleLength: 28,
      defaultPeriodLength: 5,
    );
  }
}
