import 'dart:ui';

/// Configuration for the calendar component.
///
/// Controls the calendar system, view type, display options (lunar dates,
/// holidays, solar terms), interaction modes (selection, drag, resize),
/// and date constraints.
class CalendarConfig {
  final CalendarSystem system;
  final int firstDayOfWeek;
  final Locale locale;

  final CalendarViewType viewType;
  final bool showWeekNumber;
  final bool showLunar;
  final bool showHolidays;
  final bool showSolarTerms;

  final int dayStartHour;
  final int dayEndHour;
  final int timeSlotMinutes;

  final SelectionMode selectionMode;
  final bool enableDrag;
  final bool enableResize;
  final bool enableCreate;

  final DateTime? minDate;
  final DateTime? maxDate;
  final Set<DateTime>? disabledDates;

  const CalendarConfig({
    this.system = CalendarSystem.gregorian,
    this.firstDayOfWeek = 1,
    this.locale = const Locale('zh', 'CN'),
    this.viewType = CalendarViewType.month,
    this.showWeekNumber = false,
    this.showLunar = true,
    this.showHolidays = true,
    this.showSolarTerms = true,
    this.dayStartHour = 0,
    this.dayEndHour = 24,
    this.timeSlotMinutes = 30,
    this.selectionMode = SelectionMode.single,
    this.enableDrag = false,
    this.enableResize = false,
    this.enableCreate = true,
    this.minDate,
    this.maxDate,
    this.disabledDates,
  });

  CalendarConfig copyWith({
    CalendarSystem? system,
    int? firstDayOfWeek,
    Locale? locale,
    CalendarViewType? viewType,
    bool? showWeekNumber,
    bool? showLunar,
    bool? showHolidays,
    bool? showSolarTerms,
    int? dayStartHour,
    int? dayEndHour,
    int? timeSlotMinutes,
    SelectionMode? selectionMode,
    bool? enableDrag,
    bool? enableResize,
    bool? enableCreate,
    DateTime? minDate,
    DateTime? maxDate,
    Set<DateTime>? disabledDates,
  }) {
    return CalendarConfig(
      system: system ?? this.system,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      locale: locale ?? this.locale,
      viewType: viewType ?? this.viewType,
      showWeekNumber: showWeekNumber ?? this.showWeekNumber,
      showLunar: showLunar ?? this.showLunar,
      showHolidays: showHolidays ?? this.showHolidays,
      showSolarTerms: showSolarTerms ?? this.showSolarTerms,
      dayStartHour: dayStartHour ?? this.dayStartHour,
      dayEndHour: dayEndHour ?? this.dayEndHour,
      timeSlotMinutes: timeSlotMinutes ?? this.timeSlotMinutes,
      selectionMode: selectionMode ?? this.selectionMode,
      enableDrag: enableDrag ?? this.enableDrag,
      enableResize: enableResize ?? this.enableResize,
      enableCreate: enableCreate ?? this.enableCreate,
      minDate: minDate ?? this.minDate,
      maxDate: maxDate ?? this.maxDate,
      disabledDates: disabledDates ?? this.disabledDates,
    );
  }
}

/// The calendar system (Gregorian, Lunar, Islamic, or Hebrew).
enum CalendarSystem { gregorian, lunar, islamic, hebrew }

/// The type of calendar view to display.
enum CalendarViewType { year, month, week, day, agenda, timeline }

/// The date selection mode for user interaction.
enum SelectionMode { none, single, multiple, range }
