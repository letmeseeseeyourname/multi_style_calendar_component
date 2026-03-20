import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/controllers/calendar_controller.dart';
import '../core/models/calendar_config.dart';

final calendarControllerProvider =
    ChangeNotifierProvider<CalendarController>((ref) {
  return CalendarController();
});

final calendarConfigProvider = StateProvider<CalendarConfig>((ref) {
  return const CalendarConfig();
});

final currentMonthProvider = Provider<DateTime>((ref) {
  final controller = ref.watch(calendarControllerProvider);
  return DateTime(controller.currentYear, controller.currentMonth);
});

final currentViewTypeProvider = Provider<CalendarViewType>((ref) {
  final controller = ref.watch(calendarControllerProvider);
  return controller.viewType;
});
