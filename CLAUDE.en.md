# Flutter Multi-Style Calendar Component Library

## Project Overview

A comprehensive Flutter component library demo application showcasing various calendar styles and features. It covers different calendar systems, view modes, interaction patterns, visual styles, and business scenarios, providing developers with a rich reference for calendar solutions.

## Feature Matrix

### Calendar System Support

| Calendar System | Support | Description |
|------|:----:|------|
| Gregorian Calendar | ✅ | International standard |
| Chinese Lunar Calendar | ✅ | Solar terms, zodiac, auspicious/inauspicious |
| Islamic Calendar | ✅ | Hijri months |
| Hebrew Calendar | ⚪ | Extensible |
| Buddhist Calendar | ⚪ | Extensible |

### View Modes

| View | Description | Use Cases |
|------|------|----------|
| Year View | 12-month thumbnail | Annual planning, heatmap |
| Month View | Classic 7x6 grid | General schedule management |
| Week View | Horizontal 7 days | Near-term arrangements |
| Day View | 24-hour timeline | Dense schedules |
| Agenda List | Vertical event list | To-do list |
| Timeline | Horizontal Gantt chart | Project management |
| Scroll Picker | Infinite scrolling | Date picker |

### Interaction Capabilities

| Feature | Support |
|------|:----:|
| Single Date Selection | ✅ |
| Multi Date Selection | ✅ |
| Range Selection | ✅ |
| Event CRUD | ✅ |
| Drag to Move Events | ✅ |
| Drag to Resize Duration | ✅ |
| Pinch to Zoom | ✅ |
| Swipe to Switch | ✅ |

## Tech Stack

| Category | Choice |
|------|------|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| State Management | Riverpod 2.x |
| Local Storage | Hive / Isar |
| Lunar Algorithm | `lunar` package + custom |
| Date Handling | `intl` + `jiffy` |
| Animation | `flutter_animate` |
| Drag & Drop | Custom gestures |
| Charts | `fl_chart` (heatmap) |

## Project Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── calendar_system/              # Calendar systems
│   │   ├── gregorian_calendar.dart   # Gregorian calendar
│   │   ├── lunar_calendar.dart       # Chinese Lunar calendar
│   │   ├── islamic_calendar.dart     # Islamic calendar
│   │   └── calendar_converter.dart   # Calendar conversion
│   │
│   ├── models/
│   │   ├── calendar_date.dart        # Date model
│   │   ├── calendar_event.dart       # Event model
│   │   ├── date_range.dart           # Date range
│   │   ├── time_slot.dart            # Time slot
│   │   └── calendar_config.dart      # Calendar configuration
│   │
│   ├── controllers/
│   │   ├── calendar_controller.dart  # Core controller
│   │   ├── selection_controller.dart # Selection control
│   │   ├── event_controller.dart     # Event management
│   │   └── drag_controller.dart      # Drag control
│   │
│   └── utils/
│       ├── date_utils.dart           # Date utilities
│       ├── lunar_utils.dart          # Lunar calendar utilities
│       ├── solar_terms.dart          # 24 Solar Terms
│       └── holidays.dart             # Holiday data
│
├── views/                            # View modes
│   ├── year_view/
│   │   ├── year_view.dart            # Year view
│   │   ├── year_month_cell.dart      # Month cell
│   │   └── year_heatmap.dart         # Year heatmap
│   │
│   ├── month_view/
│   │   ├── month_view.dart           # Month view
│   │   ├── month_grid.dart           # Month grid
│   │   ├── day_cell.dart             # Day cell
│   │   └── week_header.dart          # Week header
│   │
│   ├── week_view/
│   │   ├── week_view.dart            # Week view
│   │   ├── week_timeline.dart        # Week timeline
│   │   └── week_day_column.dart      # Day column
│   │
│   ├── day_view/
│   │   ├── day_view.dart             # Day view
│   │   ├── hour_row.dart             # Hour row
│   │   ├── time_indicator.dart       # Current time indicator
│   │   └── event_card.dart           # Event card
│   │
│   ├── agenda_view/
│   │   ├── agenda_view.dart          # Agenda list
│   │   ├── agenda_item.dart          # Agenda item
│   │   └── agenda_group.dart         # Date group
│   │
│   ├── timeline_view/
│   │   ├── timeline_view.dart        # Timeline / Gantt chart
│   │   ├── timeline_track.dart       # Timeline track
│   │   └── timeline_event.dart       # Timeline event
│   │
│   └── scroll_picker/
│       ├── scroll_date_picker.dart   # Scroll date picker
│       ├── wheel_picker.dart         # Wheel picker
│       └── infinite_scroll.dart      # Infinite scroll
│
├── styles/                           # Visual styles
│   ├── classic_grid/                 # Classic grid
│   │   └── classic_grid_style.dart
│   │
│   ├── card_style/                   # Card style
│   │   └── card_calendar.dart
│   │
│   ├── circular/                     # Circular / Ring
│   │   ├── circular_week.dart        # Circular week view
│   │   ├── ring_month.dart           # Ring month view
│   │   └── clock_day.dart            # Clock-style day view
│   │
│   ├── heatmap/                      # Heatmap
│   │   ├── github_heatmap.dart       # GitHub style
│   │   └── activity_heatmap.dart     # Activity heatmap
│   │
│   ├── flip_calendar/                # 3D Flip
│   │   ├── flip_calendar.dart
│   │   └── flip_animation.dart
│   │
│   ├── minimal/                      # Minimal style
│   │   └── minimal_calendar.dart
│   │
│   └── glassmorphism/                # Glassmorphism style
│       └── glass_calendar.dart
│
├── pickers/                          # Date pickers
│   ├── single_picker.dart            # Single selection
│   ├── multi_picker.dart             # Multi selection
│   ├── range_picker.dart             # Range selection
│   ├── month_picker.dart             # Month picker
│   ├── year_picker.dart              # Year picker
│   └── datetime_picker.dart          # DateTime picker
│
├── business/                         # Business scenarios
│   ├── attendance/                   # Attendance calendar
│   │   ├── attendance_calendar.dart
│   │   ├── attendance_status.dart
│   │   └── attendance_stats.dart
│   │
│   ├── period_tracker/               # Period tracker calendar
│   │   ├── period_calendar.dart
│   │   ├── cycle_predictor.dart
│   │   └── symptom_logger.dart
│   │
│   ├── habit_tracker/                # Habit tracker
│   │   ├── habit_calendar.dart
│   │   ├── streak_counter.dart
│   │   └── habit_stats.dart
│   │
│   ├── booking/                      # Booking calendar
│   │   ├── booking_calendar.dart
│   │   ├── time_slot_picker.dart
│   │   └── availability_grid.dart
│   │
│   ├── hotel_pricing/                # Hotel pricing calendar
│   │   ├── price_calendar.dart
│   │   └── room_availability.dart
│   │
│   ├── lunar_calendar/               # Chinese Lunar calendar
│   │   ├── chinese_calendar.dart
│   │   ├── festival_display.dart
│   │   └── fortune_display.dart
│   │
│   ├── countdown/                    # Countdown calendar
│   │   ├── countdown_calendar.dart
│   │   └── milestone_tracker.dart
│   │
│   └── shared_calendar/              # Shared calendar
│       ├── shared_calendar.dart
│       ├── member_colors.dart
│       └── conflict_detector.dart
│
├── widgets/                          # Common widgets
│   ├── calendar_header.dart          # Calendar header
│   ├── navigation_buttons.dart       # Navigation buttons
│   ├── view_switcher.dart            # View switcher
│   ├── event_popup.dart              # Event popup
│   ├── event_form.dart               # Event form
│   ├── draggable_event.dart          # Draggable event
│   ├── resizable_event.dart          # Resizable event
│   ├── time_ruler.dart               # Time ruler
│   └── lunar_info_badge.dart         # Lunar info badge
│
├── screens/                          # Demo pages
│   ├── home_screen.dart              # Home navigation
│   ├── view_demo_screen.dart         # View demo
│   ├── style_demo_screen.dart        # Style demo
│   ├── picker_demo_screen.dart       # Picker demo
│   ├── business_demo_screen.dart     # Business scenario demo
│   └── playground_screen.dart        # Free configuration
│
├── providers/
│   ├── calendar_provider.dart
│   ├── events_provider.dart
│   ├── settings_provider.dart
│   └── theme_provider.dart
│
└── theme/
    ├── app_theme.dart
    ├── calendar_theme.dart
    ├── color_schemes.dart
    └── text_styles.dart

assets/
├── fonts/
├── icons/
└── data/
    ├── holidays_cn.json              # Chinese holidays
    ├── holidays_us.json              # US holidays
    └── solar_terms.json              # Solar terms data
```

## Core Data Models

### Date Model

```dart
/// Universal calendar date with multi-calendar system support
class CalendarDate {
  final DateTime gregorian;           // Gregorian date
  final LunarDate? lunar;             // Chinese Lunar date
  final IslamicDate? islamic;         // Islamic date

  final bool isToday;
  final bool isWeekend;
  final bool isHoliday;
  final String? holidayName;

  // Lunar calendar related
  final String? solarTerm;            // Solar term
  final String? lunarFestival;        // Lunar festival
  final String? zodiac;               // Zodiac animal

  CalendarDate({
    required this.gregorian,
    this.lunar,
    this.islamic,
  });

  factory CalendarDate.fromDateTime(DateTime date) {
    return CalendarDate(
      gregorian: date,
      lunar: LunarCalendar.fromGregorian(date),
    );
  }
}

/// Chinese Lunar date
class LunarDate {
  final int year;                     // Lunar year
  final int month;                    // Lunar month
  final int day;                      // Lunar day
  final bool isLeapMonth;             // Whether it is a leap month

  final String yearGanZhi;            // Year Heavenly Stems & Earthly Branches (e.g., Jiazi)
  final String monthGanZhi;           // Month Heavenly Stems & Earthly Branches
  final String dayGanZhi;             // Day Heavenly Stems & Earthly Branches

  final String zodiac;                // Zodiac animal
  final String yearChinese;           // Chinese year (e.g., 2024 in Chinese characters)
  final String monthChinese;          // Chinese month (e.g., First Month)
  final String dayChinese;            // Chinese day (e.g., First Day)

  String get fullChinese => '$monthChinese$dayChinese';
}
```

### Event Model

```dart
/// Calendar event
class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;

  final Color color;
  final String? icon;
  final EventRepeat? repeat;          // Repeat rule
  final EventReminder? reminder;      // Reminder settings

  final String? location;
  final List<String>? attendees;      // Attendees
  final String? createdBy;            // Creator

  final Map<String, dynamic>? extra;  // Extended data

  Duration get duration => endTime.difference(startTime);
  bool get isMultiDay => !startTime.isSameDay(endTime);

  bool occursOn(DateTime date) {
    if (isAllDay) {
      return date.isAfterOrEqual(startTime.dateOnly) &&
             date.isBeforeOrEqual(endTime.dateOnly);
    }
    return date.isSameDay(startTime) || date.isSameDay(endTime);
  }
}

/// Repeat rule
class EventRepeat {
  final RepeatType type;              // daily/weekly/monthly/yearly
  final int interval;                 // Interval
  final List<int>? weekdays;          // Day of week (weekly)
  final int? dayOfMonth;              // Day of month (monthly)
  final DateTime? endDate;            // End date
  final int? occurrences;             // Repeat count
}
```

### Calendar Configuration

```dart
/// Calendar configuration
class CalendarConfig {
  // Basic configuration
  final CalendarSystem system;        // Calendar system
  final int firstDayOfWeek;           // First day of week (1=Monday, 7=Sunday)
  final Locale locale;                // Locale

  // View configuration
  final CalendarViewType viewType;    // Current view
  final bool showWeekNumber;          // Show week number
  final bool showLunar;               // Show lunar calendar
  final bool showHolidays;            // Show holidays
  final bool showSolarTerms;          // Show solar terms

  // Time configuration
  final int dayStartHour;             // Day view start hour
  final int dayEndHour;               // Day view end hour
  final int timeSlotMinutes;          // Time slot in minutes

  // Interaction configuration
  final SelectionMode selectionMode;  // Selection mode
  final bool enableDrag;              // Enable drag
  final bool enableResize;            // Enable resize
  final bool enableCreate;            // Enable event creation

  // Display range
  final DateTime? minDate;
  final DateTime? maxDate;
  final Set<DateTime>? disabledDates;
}

enum CalendarSystem { gregorian, lunar, islamic, hebrew }
enum CalendarViewType { year, month, week, day, agenda, timeline }
enum SelectionMode { none, single, multiple, range }
```

## View Implementation Specifications

### Month View (MonthView)

```dart
class MonthView extends StatelessWidget {
  final DateTime month;
  final CalendarConfig config;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime>? onDateTap;
  final ValueChanged<DateRange>? onRangeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Week header row
        WeekHeader(
          firstDayOfWeek: config.firstDayOfWeek,
          locale: config.locale,
        ),
        // Date grid
        Expanded(
          child: MonthGrid(
            month: month,
            config: config,
            events: events,
            onDateTap: onDateTap,
          ),
        ),
      ],
    );
  }
}

/// Day cell
class DayCell extends StatelessWidget {
  final CalendarDate date;
  final List<CalendarEvent> events;
  final bool isSelected;
  final bool isInRange;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildDecoration(),
      child: Column(
        children: [
          // Gregorian date
          Text(
            '${date.gregorian.day}',
            style: _getDateTextStyle(),
          ),
          // Lunar date (optional)
          if (config.showLunar && date.lunar != null)
            Text(
              date.solarTerm ?? date.lunar!.dayChinese,
              style: _getLunarTextStyle(),
            ),
          // Event indicators
          if (events.isNotEmpty)
            EventDots(events: events, maxDots: 3),
        ],
      ),
    );
  }
}
```

### Day View (DayView)

```dart
class DayView extends StatefulWidget {
  final DateTime date;
  final CalendarConfig config;
  final List<CalendarEvent> events;

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final hourHeight = 60.0;
    final totalHours = widget.config.dayEndHour - widget.config.dayStartHour;

    return Stack(
      children: [
        // Time grid background
        SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            height: hourHeight * totalHours,
            child: Stack(
              children: [
                // Hour divider lines
                ...List.generate(totalHours, (i) => HourRow(
                  hour: widget.config.dayStartHour + i,
                  top: i * hourHeight,
                )),
                // Event cards
                ...widget.events.map((e) => Positioned(
                  top: _calculateTop(e.startTime),
                  left: 60,
                  right: 8,
                  height: _calculateHeight(e),
                  child: DraggableEventCard(event: e),
                )),
                // Current time indicator line
                if (widget.date.isToday)
                  CurrentTimeIndicator(
                    top: _calculateCurrentTimeTop(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateTop(DateTime time) {
    final minutes = time.hour * 60 + time.minute;
    final startMinutes = widget.config.dayStartHour * 60;
    return (minutes - startMinutes) * (60.0 / 60);
  }
}
```

### Week View (WeekView)

```dart
class WeekView extends StatelessWidget {
  final DateTime weekStart;
  final CalendarConfig config;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time ruler column
        TimeRuler(
          startHour: config.dayStartHour,
          endHour: config.dayEndHour,
        ),
        // 7-day columns
        ...List.generate(7, (i) {
          final date = weekStart.add(Duration(days: i));
          final dayEvents = events.where((e) => e.occursOn(date)).toList();
          return Expanded(
            child: WeekDayColumn(
              date: date,
              events: dayEvents,
              config: config,
            ),
          );
        }),
      ],
    );
  }
}
```

### Year Heatmap (YearHeatmap)

```dart
class YearHeatmap extends StatelessWidget {
  final int year;
  final Map<DateTime, int> data;      // Date -> intensity value
  final Color baseColor;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month labels
        MonthLabels(year: year),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekday labels
            WeekdayLabels(),
            // Heatmap grid
            Expanded(
              child: Wrap(
                direction: Axis.vertical,
                spacing: 2,
                runSpacing: 2,
                children: _buildDayCells(),
              ),
            ),
          ],
        ),
        // Legend
        HeatmapLegend(
          baseColor: baseColor,
          levels: 5,
        ),
      ],
    );
  }

  List<Widget> _buildDayCells() {
    final firstDay = DateTime(year, 1, 1);
    final lastDay = DateTime(year, 12, 31);

    return List.generate(
      lastDay.difference(firstDay).inDays + 1,
      (i) {
        final date = firstDay.add(Duration(days: i));
        final value = data[date.dateOnly] ?? 0;
        final intensity = (value / maxValue).clamp(0.0, 1.0);

        return HeatmapCell(
          date: date,
          color: _getColorForIntensity(intensity),
          tooltip: '$value activities on ${date.formatted}',
        );
      },
    );
  }
}
```

## Interaction Feature Implementation

### Range Selection

```dart
class RangeSelectionController extends ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSelecting = false;

  DateRange? get selectedRange {
    if (_startDate != null && _endDate != null) {
      return DateRange(_startDate!, _endDate!);
    }
    return null;
  }

  void onDateTap(DateTime date) {
    if (!_isSelecting) {
      // Start selection
      _startDate = date;
      _endDate = null;
      _isSelecting = true;
    } else {
      // End selection
      if (date.isBefore(_startDate!)) {
        _endDate = _startDate;
        _startDate = date;
      } else {
        _endDate = date;
      }
      _isSelecting = false;
    }
    notifyListeners();
  }

  bool isInRange(DateTime date) {
    if (_startDate == null) return false;
    if (_endDate == null) return date.isSameDay(_startDate!);
    return date.isAfterOrEqual(_startDate!) &&
           date.isBeforeOrEqual(_endDate!);
  }

  bool isRangeStart(DateTime date) =>
    _startDate != null && date.isSameDay(_startDate!);

  bool isRangeEnd(DateTime date) =>
    _endDate != null && date.isSameDay(_endDate!);
}
```

### Drag Events

```dart
class DraggableEventCard extends StatefulWidget {
  final CalendarEvent event;
  final ValueChanged<DateTime> onDragEnd;

  @override
  State<DraggableEventCard> createState() => _DraggableEventCardState();
}

class _DraggableEventCardState extends State<DraggableEventCard> {
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _onDragStart,
      onLongPressMoveUpdate: _onDragUpdate,
      onLongPressEnd: _onDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          _dragOffset.dx,
          _dragOffset.dy,
          0,
        ),
        decoration: BoxDecoration(
          color: widget.event.color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isDragging
              ? [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )]
              : null,
        ),
        child: EventCardContent(event: widget.event),
      ),
    );
  }

  void _onDragStart(LongPressStartDetails details) {
    setState(() => _isDragging = true);
    HapticFeedback.mediumImpact();
  }

  void _onDragUpdate(LongPressMoveUpdateDetails details) {
    setState(() => _dragOffset += details.offsetFromOrigin);
  }

  void _onDragEnd(LongPressEndDetails details) {
    // Calculate new time position
    final newDateTime = _calculateNewDateTime(_dragOffset);
    widget.onDragEnd(newDateTime);

    setState(() {
      _isDragging = false;
      _dragOffset = Offset.zero;
    });
  }
}
```

### Resizable Events

```dart
class ResizableEventCard extends StatefulWidget {
  final CalendarEvent event;
  final ValueChanged<Duration> onResize;

  @override
  State<ResizableEventCard> createState() => _ResizableEventCardState();
}

class _ResizableEventCardState extends State<ResizableEventCard> {
  double _extraHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Event card body
        Container(
          height: _baseHeight + _extraHeight,
          decoration: BoxDecoration(
            color: widget.event.color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: EventCardContent(event: widget.event),
        ),
        // Bottom resize handle
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _extraHeight += details.delta.dy;
                _extraHeight = _extraHeight.clamp(-_maxShrink, _maxGrow);
              });
            },
            onVerticalDragEnd: (_) {
              final newDuration = _calculateDuration(_baseHeight + _extraHeight);
              widget.onResize(newDuration);
            },
            child: Container(
              height: 16,
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

## Business Scenario Implementation

### Attendance Calendar

```dart
/// Attendance status
enum AttendanceStatus {
  normal,       // Normal
  late,         // Late
  leaveEarly,   // Left early
  absent,       // Absent
  leave,        // On leave
  holiday,      // Holiday
  rest,         // Rest day
}

class AttendanceCalendar extends StatelessWidget {
  final Map<DateTime, AttendanceRecord> records;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Monthly statistics
        AttendanceStats(records: _currentMonthRecords),
        // Calendar view
        MonthView(
          month: _currentMonth,
          cellBuilder: (date) => AttendanceDayCell(
            date: date,
            record: records[date.dateOnly],
          ),
        ),
        // Legend
        AttendanceLegend(),
      ],
    );
  }
}

class AttendanceDayCell extends StatelessWidget {
  final CalendarDate date;
  final AttendanceRecord? record;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(record?.status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${date.gregorian.day}'),
          if (record != null)
            _buildStatusIcon(record!.status),
          if (record?.checkInTime != null)
            Text(
              record!.checkInTime!.format('HH:mm'),
              style: TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }
}
```

### Habit Tracker Calendar

```dart
class HabitCalendar extends StatelessWidget {
  final String habitId;
  final Map<DateTime, bool> completions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Streak count
        StreakDisplay(
          currentStreak: _calculateCurrentStreak(),
          longestStreak: _calculateLongestStreak(),
        ),
        // Monthly completion rate
        CompletionRate(
          completed: _monthCompletedDays,
          total: _monthTotalDays,
        ),
        // Heatmap calendar
        YearHeatmap(
          year: DateTime.now().year,
          data: completions.map((k, v) => MapEntry(k, v ? 1 : 0)),
          baseColor: Colors.green,
        ),
        // Month view (switchable)
        MonthView(
          cellBuilder: (date) => HabitDayCell(
            date: date,
            isCompleted: completions[date.dateOnly] ?? false,
            onTap: () => _toggleCompletion(date),
          ),
        ),
      ],
    );
  }

  int _calculateCurrentStreak() {
    int streak = 0;
    var date = DateTime.now();
    while (completions[date.dateOnly] == true) {
      streak++;
      date = date.subtract(Duration(days: 1));
    }
    return streak;
  }
}
```

### Hotel Pricing Calendar

```dart
class HotelPriceCalendar extends StatelessWidget {
  final Map<DateTime, PriceInfo> prices;
  final DateRange? selectedRange;
  final ValueChanged<DateRange> onRangeSelected;

  @override
  Widget build(BuildContext context) {
    return MonthView(
      config: CalendarConfig(
        selectionMode: SelectionMode.range,
      ),
      cellBuilder: (date) => PriceDayCell(
        date: date,
        priceInfo: prices[date.dateOnly],
        isCheckIn: selectedRange?.start.isSameDay(date) ?? false,
        isCheckOut: selectedRange?.end.isSameDay(date) ?? false,
        isInRange: selectedRange?.contains(date) ?? false,
      ),
      onRangeSelected: onRangeSelected,
      footer: selectedRange != null
          ? PriceSummary(
              range: selectedRange!,
              prices: prices,
            )
          : null,
    );
  }
}

class PriceDayCell extends StatelessWidget {
  final CalendarDate date;
  final PriceInfo? priceInfo;

  @override
  Widget build(BuildContext context) {
    final isAvailable = priceInfo?.isAvailable ?? true;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.4,
      child: Container(
        decoration: _buildDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${date.gregorian.day}'),
            if (priceInfo != null)
              Text(
                '¥${priceInfo!.price}',
                style: TextStyle(
                  fontSize: 10,
                  color: _getPriceColor(priceInfo!.priceLevel),
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (priceInfo?.roomsLeft != null && priceInfo!.roomsLeft! < 5)
              Text(
                '${priceInfo!.roomsLeft} rooms left',
                style: TextStyle(fontSize: 8, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
```

### Chinese Lunar Calendar

```dart
class ChineseCalendar extends StatelessWidget {
  final DateTime month;
  final bool showFortune;

  @override
  Widget build(BuildContext context) {
    return MonthView(
      month: month,
      config: CalendarConfig(
        showLunar: true,
        showSolarTerms: true,
        showHolidays: true,
      ),
      cellBuilder: (date) => ChineseDayCell(date: date),
      headerBuilder: (month) => ChineseMonthHeader(
        gregorianMonth: month,
        lunarMonth: LunarCalendar.fromGregorian(month),
      ),
      onDateTap: showFortune ? _showDayFortune : null,
    );
  }

  void _showDayFortune(DateTime date) {
    final lunar = LunarCalendar.fromGregorian(date);
    showModalBottomSheet(
      context: context,
      builder: (_) => FortuneSheet(
        date: date,
        lunar: lunar,
        suitable: lunar.suitable,   // Auspicious
        avoid: lunar.avoid,         // Inauspicious
        conflictZodiac: lunar.conflictZodiac,  // Zodiac conflict
      ),
    );
  }
}

class ChineseDayCell extends StatelessWidget {
  final CalendarDate date;

  @override
  Widget build(BuildContext context) {
    final lunar = date.lunar!;
    final displayText = date.solarTerm ??
                        date.lunarFestival ??
                        date.holidayName ??
                        lunar.dayChinese;

    final isSpecial = date.solarTerm != null ||
                      date.lunarFestival != null ||
                      date.holidayName != null;

    return Container(
      decoration: BoxDecoration(
        color: date.isToday ? primaryColor : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.gregorian.day}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: date.isToday ? FontWeight.bold : null,
            ),
          ),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 10,
              color: isSpecial ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
```

## Design Specifications

### Color System

```dart
class CalendarColors {
  // Theme colors
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);

  // Date colors
  static const Color today = Color(0xFF2196F3);
  static const Color selected = Color(0xFF1976D2);
  static const Color inRange = Color(0xFFBBDEFB);
  static const Color weekend = Color(0xFFEF5350);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color holiday = Color(0xFFE91E63);

  // Event color presets
  static const List<Color> eventColors = [
    Color(0xFF4CAF50),  // Green
    Color(0xFF2196F3),  // Blue
    Color(0xFFFF9800),  // Orange
    Color(0xFF9C27B0),  // Purple
    Color(0xFFE91E63),  // Pink
    Color(0xFF00BCD4),  // Cyan
    Color(0xFF795548),  // Brown
    Color(0xFF607D8B),  // Blue-grey
  ];

  // Heatmap colors
  static Color heatmapColor(double intensity, Color base) {
    return Color.lerp(
      base.withOpacity(0.1),
      base,
      intensity,
    )!;
  }
}
```

### Dimension Specifications

```dart
class CalendarDimens {
  // Cell
  static const double cellMinHeight = 40;
  static const double cellPadding = 4;
  static const double cellRadius = 8;

  // Event
  static const double eventHeight = 20;
  static const double eventSpacing = 2;
  static const double eventRadius = 4;

  // Time view
  static const double hourHeight = 60;
  static const double timeColumnWidth = 56;
  static const double timeIndicatorHeight = 2;

  // Header
  static const double headerHeight = 48;
  static const double weekHeaderHeight = 32;

  // Spacing
  static const double viewPadding = 16;
  static const double sectionSpacing = 24;
}
```

### Animation Specifications

```dart
class CalendarAnimations {
  // Page switching
  static const Duration pageSwitch = Duration(milliseconds: 300);
  static const Curve pageCurve = Curves.easeOutCubic;

  // Selection feedback
  static const Duration selection = Duration(milliseconds: 200);
  static const Curve selectionCurve = Curves.easeOut;

  // Drag
  static const Duration dragStart = Duration(milliseconds: 150);
  static const Duration dragEnd = Duration(milliseconds: 200);

  // Expand / Collapse
  static const Duration expand = Duration(milliseconds: 250);
  static const Curve expandCurve = Curves.easeInOut;

  // Flip calendar
  static const Duration flip = Duration(milliseconds: 500);
  static const Curve flipCurve = Curves.easeInOutBack;
}
```

## Dependencies

```yaml
name: flutter_calendar_collection
description: Multi-style calendar component library demo

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.4.9

  # Date handling
  intl: ^0.18.1
  jiffy: ^6.2.1

  # Lunar calendar algorithm
  lunar: ^1.3.8

  # Local storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Animation
  flutter_animate: ^4.5.0

  # Charts (heatmap)
  fl_chart: ^0.66.0

  # UI components
  google_fonts: ^6.1.0
  flutter_slidable: ^3.0.1

  # Utilities
  collection: ^1.18.0
  equatable: ^2.0.5
  uuid: ^4.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

## Implementation Priority

### P0 - Core Foundation

1. ✅ Project structure
2. ✅ Core data models
3. ✅ Gregorian calendar system
4. ✅ Month view basic implementation
5. ✅ Single date selection feature
6. ✅ Home demo navigation

### P1 - View Completion

7. Week view implementation
8. Day view implementation
9. Year view implementation
10. Range selection
11. Event display and management
12. Chinese Lunar calendar support

### P2 - Styles & Interaction

13. Heatmap style
14. Card style
15. Circular / Ring style
16. Flip calendar
17. Drag events
18. Resize event duration

### P3 - Business Scenarios

19. Attendance calendar
20. Habit tracker
21. Booking calendar
22. Pricing calendar
23. Shared calendar

### P4 - Enhanced Features

24. Islamic calendar support
25. Animation optimization
26. Theme switching
27. Internationalization
28. Performance optimization

## Startup Commands

```bash
# Install dependencies
flutter pub get

# Run
flutter run

# Build
flutter build apk --release
```

## Notes

1. **Lunar Algorithm**: The `lunar` package supports the year range 1900-2100
2. **Holiday Data**: Needs periodic updates; recommended to fetch from a server
3. **Performance**: Year view heatmap involves large data volumes; virtualized rendering is needed
4. **Time Zones**: Cross-timezone events require special handling
5. **Accessibility**: Add semantic labels to date cells
6. **Testing**: Pay attention to edge cases such as leap years, end of month, and year transitions
