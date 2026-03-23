/// A comprehensive Flutter calendar widget library featuring multiple view modes,
/// visual styles, date pickers, and business scenarios.
library;

// Core - Models
export 'core/models/calendar_date.dart';
export 'core/models/calendar_event.dart';
export 'core/models/calendar_config.dart';
export 'core/models/date_range.dart';
export 'core/models/time_slot.dart';

// Core - Calendar Systems
export 'core/calendar_system/gregorian_calendar.dart';
export 'core/calendar_system/lunar_calendar.dart';
export 'core/calendar_system/islamic_calendar.dart';
export 'core/calendar_system/calendar_converter.dart';

// Core - Controllers
export 'core/controllers/calendar_controller.dart';
export 'core/controllers/selection_controller.dart';
export 'core/controllers/event_controller.dart';
export 'core/controllers/drag_controller.dart';

// Core - Utils
export 'core/utils/date_utils.dart';
export 'core/utils/lunar_utils.dart';
export 'core/utils/solar_terms.dart';
export 'core/utils/holidays.dart';

// Views
export 'views/month_view/month_grid.dart';
export 'views/month_view/day_cell.dart';
export 'views/month_view/week_header.dart';
export 'views/week_view/week_view.dart';
export 'views/week_view/week_timeline.dart';
export 'views/week_view/week_day_column.dart';
export 'views/day_view/day_view.dart';
export 'views/day_view/hour_row.dart';
export 'views/day_view/time_indicator.dart';
export 'views/day_view/event_card.dart';
export 'views/year_view/year_view.dart';
export 'views/year_view/year_month_cell.dart';
export 'views/year_view/year_heatmap.dart';
export 'views/agenda_view/agenda_view.dart';
export 'views/agenda_view/agenda_item.dart';
export 'views/agenda_view/agenda_group.dart';
export 'views/timeline_view/timeline_view.dart';
export 'views/timeline_view/timeline_track.dart';
export 'views/timeline_view/timeline_event.dart';
export 'views/scroll_picker/scroll_date_picker.dart';
export 'views/scroll_picker/wheel_picker.dart';
export 'views/scroll_picker/infinite_scroll.dart';

// Styles
export 'styles/classic_grid/classic_grid_style.dart';
export 'styles/card_style/card_calendar.dart';
export 'styles/circular/circular_week.dart' hide AnimatedBuilder;
export 'styles/circular/ring_month.dart' hide AnimatedBuilder;
export 'styles/circular/clock_day.dart' hide AnimatedBuilder;
export 'styles/heatmap/github_heatmap.dart';
export 'styles/heatmap/activity_heatmap.dart';
export 'styles/flip_calendar/flip_calendar.dart' hide AnimatedBuilder;
export 'styles/flip_calendar/flip_animation.dart' hide AnimatedBuilder;
export 'styles/minimal/minimal_calendar.dart';
export 'styles/glassmorphism/glass_calendar.dart';

// Pickers
export 'pickers/single_picker.dart';
export 'pickers/multi_picker.dart';
export 'pickers/range_picker.dart';
export 'pickers/month_picker.dart';
export 'pickers/year_picker.dart';
export 'pickers/datetime_picker.dart';

// Business Scenarios
export 'business/attendance/attendance_calendar.dart';
export 'business/attendance/attendance_status.dart';
export 'business/attendance/attendance_stats.dart';
export 'business/habit_tracker/habit_calendar.dart';
export 'business/habit_tracker/streak_counter.dart';
export 'business/habit_tracker/habit_stats.dart';
export 'business/booking/booking_calendar.dart';
export 'business/booking/time_slot_picker.dart';
export 'business/booking/availability_grid.dart';
export 'business/hotel_pricing/price_calendar.dart';
export 'business/hotel_pricing/room_availability.dart';
export 'business/lunar_calendar/chinese_calendar.dart';
export 'business/lunar_calendar/festival_display.dart';
export 'business/lunar_calendar/fortune_display.dart';
export 'business/countdown/countdown_calendar.dart';
export 'business/countdown/milestone_tracker.dart';
export 'business/shared_calendar/shared_calendar.dart';
export 'business/shared_calendar/member_colors.dart';
export 'business/shared_calendar/conflict_detector.dart';
export 'business/period_tracker/period_calendar.dart';
export 'business/period_tracker/cycle_predictor.dart';
export 'business/period_tracker/symptom_logger.dart';

// Widgets
export 'widgets/calendar_header.dart';
export 'widgets/navigation_buttons.dart';
export 'widgets/view_switcher.dart';
export 'widgets/event_popup.dart';
export 'widgets/event_form.dart';
export 'widgets/draggable_event.dart';
export 'widgets/resizable_event.dart';
export 'widgets/time_ruler.dart';
export 'widgets/lunar_info_badge.dart';

// Theme
export 'theme/app_theme.dart';
export 'theme/calendar_theme.dart';
export 'theme/color_schemes.dart';
export 'theme/text_styles.dart';

// Providers
export 'providers/calendar_provider.dart';
export 'providers/events_provider.dart';
export 'providers/theme_provider.dart';
export 'providers/settings_provider.dart';

// Localization
export 'l10n/app_localizations.dart';
