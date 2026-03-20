# 📅 Flutter 多样式日历组件库

## 项目概述

一个全面展示多种日历样式与功能的 Flutter 组件库演示应用。涵盖不同历法体系、视图模式、交互形式、视觉风格和业务场景，为开发者提供丰富的日历解决方案参考。

## 功能矩阵

### 历法支持

| 历法 | 支持 | 说明 |
|------|:----:|------|
| 公历（格里高利历） | ✅ | 国际通用标准 |
| 中国农历 | ✅ | 节气、生肖、宜忌 |
| 伊斯兰历 | ✅ | 回历月份 |
| 希伯来历 | ⚪ | 可扩展 |
| 佛历 | ⚪ | 可扩展 |

### 视图模式

| 视图 | 描述 | 适用场景 |
|------|------|----------|
| 年视图 | 12 个月缩略图 | 年度规划、热力图 |
| 月视图 | 经典 7×6 网格 | 通用日程管理 |
| 周视图 | 横向 7 天 | 近期安排 |
| 日视图 | 24 小时时间轴 | 密集日程 |
| 日程列表 | 垂直事件列表 | 待办清单 |
| 时间线 | 横向甘特图 | 项目管理 |
| 滚动选择 | 无限滚动 | 日期选择器 |

### 交互能力

| 功能 | 支持 |
|------|:----:|
| 单选日期 | ✅ |
| 多选日期 | ✅ |
| 范围选择 | ✅ |
| 事件增删改 | ✅ |
| 拖拽移动事件 | ✅ |
| 拖拽调整时长 | ✅ |
| 手势缩放 | ✅ |
| 滑动切换 | ✅ |

## 技术栈

| 类别 | 选型 |
|------|------|
| 框架 | Flutter 3.x |
| 语言 | Dart 3.x |
| 状态管理 | Riverpod 2.x |
| 本地存储 | Hive / Isar |
| 农历算法 | `lunar` 包 + 自定义 |
| 日期处理 | `intl` + `jiffy` |
| 动画 | `flutter_animate` |
| 拖拽 | 自定义手势 |
| 图表 | `fl_chart` (热力图) |

## 项目结构

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── calendar_system/              # 历法系统
│   │   ├── gregorian_calendar.dart   # 公历
│   │   ├── lunar_calendar.dart       # 农历
│   │   ├── islamic_calendar.dart     # 伊斯兰历
│   │   └── calendar_converter.dart   # 历法转换
│   │
│   ├── models/
│   │   ├── calendar_date.dart        # 日期模型
│   │   ├── calendar_event.dart       # 事件模型
│   │   ├── date_range.dart           # 日期范围
│   │   ├── time_slot.dart            # 时间段
│   │   └── calendar_config.dart      # 日历配置
│   │
│   ├── controllers/
│   │   ├── calendar_controller.dart  # 核心控制器
│   │   ├── selection_controller.dart # 选择控制
│   │   ├── event_controller.dart     # 事件管理
│   │   └── drag_controller.dart      # 拖拽控制
│   │
│   └── utils/
│       ├── date_utils.dart           # 日期工具
│       ├── lunar_utils.dart          # 农历工具
│       ├── solar_terms.dart          # 二十四节气
│       └── holidays.dart             # 节假日数据
│
├── views/                            # 视图模式
│   ├── year_view/
│   │   ├── year_view.dart            # 年视图
│   │   ├── year_month_cell.dart      # 月份单元格
│   │   └── year_heatmap.dart         # 年度热力图
│   │
│   ├── month_view/
│   │   ├── month_view.dart           # 月视图
│   │   ├── month_grid.dart           # 月网格
│   │   ├── day_cell.dart             # 日期单元格
│   │   └── week_header.dart          # 周标题
│   │
│   ├── week_view/
│   │   ├── week_view.dart            # 周视图
│   │   ├── week_timeline.dart        # 周时间线
│   │   └── week_day_column.dart      # 日列
│   │
│   ├── day_view/
│   │   ├── day_view.dart             # 日视图
│   │   ├── hour_row.dart             # 小时行
│   │   ├── time_indicator.dart       # 当前时间指示
│   │   └── event_card.dart           # 事件卡片
│   │
│   ├── agenda_view/
│   │   ├── agenda_view.dart          # 日程列表
│   │   ├── agenda_item.dart          # 日程项
│   │   └── agenda_group.dart         # 日期分组
│   │
│   ├── timeline_view/
│   │   ├── timeline_view.dart        # 时间线/甘特图
│   │   ├── timeline_track.dart       # 时间轨道
│   │   └── timeline_event.dart       # 时间线事件
│   │
│   └── scroll_picker/
│       ├── scroll_date_picker.dart   # 滚动选择器
│       ├── wheel_picker.dart         # 滚轮选择
│       └── infinite_scroll.dart      # 无限滚动
│
├── styles/                           # 视觉风格
│   ├── classic_grid/                 # 传统网格
│   │   └── classic_grid_style.dart
│   │
│   ├── card_style/                   # 卡片式
│   │   └── card_calendar.dart
│   │
│   ├── circular/                     # 圆形/环形
│   │   ├── circular_week.dart        # 圆形周视图
│   │   ├── ring_month.dart           # 环形月视图
│   │   └── clock_day.dart            # 时钟式日视图
│   │
│   ├── heatmap/                      # 热力图
│   │   ├── github_heatmap.dart       # GitHub 风格
│   │   └── activity_heatmap.dart     # 活动热力图
│   │
│   ├── flip_calendar/                # 3D 翻页
│   │   ├── flip_calendar.dart
│   │   └── flip_animation.dart
│   │
│   ├── minimal/                      # 极简风格
│   │   └── minimal_calendar.dart
│   │
│   └── glassmorphism/                # 毛玻璃风格
│       └── glass_calendar.dart
│
├── pickers/                          # 日期选择器
│   ├── single_picker.dart            # 单选
│   ├── multi_picker.dart             # 多选
│   ├── range_picker.dart             # 范围选择
│   ├── month_picker.dart             # 月份选择
│   ├── year_picker.dart              # 年份选择
│   └── datetime_picker.dart          # 日期时间选择
│
├── business/                         # 业务场景
│   ├── attendance/                   # 考勤日历
│   │   ├── attendance_calendar.dart
│   │   ├── attendance_status.dart
│   │   └── attendance_stats.dart
│   │
│   ├── period_tracker/               # 经期日历
│   │   ├── period_calendar.dart
│   │   ├── cycle_predictor.dart
│   │   └── symptom_logger.dart
│   │
│   ├── habit_tracker/                # 习惯追踪
│   │   ├── habit_calendar.dart
│   │   ├── streak_counter.dart
│   │   └── habit_stats.dart
│   │
│   ├── booking/                      # 预约日历
│   │   ├── booking_calendar.dart
│   │   ├── time_slot_picker.dart
│   │   └── availability_grid.dart
│   │
│   ├── hotel_pricing/                # 酒店价格日历
│   │   ├── price_calendar.dart
│   │   └── room_availability.dart
│   │
│   ├── lunar_calendar/               # 农历日历
│   │   ├── chinese_calendar.dart
│   │   ├── festival_display.dart
│   │   └── fortune_display.dart
│   │
│   ├── countdown/                    # 倒计时日历
│   │   ├── countdown_calendar.dart
│   │   └── milestone_tracker.dart
│   │
│   └── shared_calendar/              # 共享日历
│       ├── shared_calendar.dart
│       ├── member_colors.dart
│       └── conflict_detector.dart
│
├── widgets/                          # 通用组件
│   ├── calendar_header.dart          # 日历头部
│   ├── navigation_buttons.dart       # 导航按钮
│   ├── view_switcher.dart            # 视图切换
│   ├── event_popup.dart              # 事件弹窗
│   ├── event_form.dart               # 事件表单
│   ├── draggable_event.dart          # 可拖拽事件
│   ├── resizable_event.dart          # 可调整大小
│   ├── time_ruler.dart               # 时间刻度尺
│   └── lunar_info_badge.dart         # 农历信息标签
│
├── screens/                          # 演示页面
│   ├── home_screen.dart              # 首页导航
│   ├── view_demo_screen.dart         # 视图演示
│   ├── style_demo_screen.dart        # 风格演示
│   ├── picker_demo_screen.dart       # 选择器演示
│   ├── business_demo_screen.dart     # 业务场景演示
│   └── playground_screen.dart        # 自由配置
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
    ├── holidays_cn.json              # 中国节假日
    ├── holidays_us.json              # 美国节假日
    └── solar_terms.json              # 节气数据
```

## 核心数据模型

### 日期模型

```dart
/// 通用日历日期，支持多历法
class CalendarDate {
  final DateTime gregorian;           // 公历日期
  final LunarDate? lunar;             // 农历日期
  final IslamicDate? islamic;         // 伊斯兰历
  
  final bool isToday;
  final bool isWeekend;
  final bool isHoliday;
  final String? holidayName;
  
  // 农历相关
  final String? solarTerm;            // 节气
  final String? lunarFestival;        // 农历节日
  final String? zodiac;               // 生肖
  
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

/// 农历日期
class LunarDate {
  final int year;                     // 农历年
  final int month;                    // 农历月
  final int day;                      // 农历日
  final bool isLeapMonth;             // 是否闰月
  
  final String yearGanZhi;            // 年干支 (甲子)
  final String monthGanZhi;           // 月干支
  final String dayGanZhi;             // 日干支
  
  final String zodiac;                // 生肖
  final String yearChinese;           // 中文年 (二零二四)
  final String monthChinese;          // 中文月 (正月)
  final String dayChinese;            // 中文日 (初一)
  
  String get fullChinese => '$monthChinese$dayChinese';
}
```

### 事件模型

```dart
/// 日历事件
class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  
  final Color color;
  final String? icon;
  final EventRepeat? repeat;          // 重复规则
  final EventReminder? reminder;      // 提醒设置
  
  final String? location;
  final List<String>? attendees;      // 参与者
  final String? createdBy;            // 创建者
  
  final Map<String, dynamic>? extra;  // 扩展数据
  
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

/// 重复规则
class EventRepeat {
  final RepeatType type;              // daily/weekly/monthly/yearly
  final int interval;                 // 间隔
  final List<int>? weekdays;          // 周几 (weekly)
  final int? dayOfMonth;              // 几号 (monthly)
  final DateTime? endDate;            // 结束日期
  final int? occurrences;             // 重复次数
}
```

### 日历配置

```dart
/// 日历配置
class CalendarConfig {
  // 基础配置
  final CalendarSystem system;        // 历法系统
  final int firstDayOfWeek;           // 周起始日 (1=周一, 7=周日)
  final Locale locale;                // 语言区域
  
  // 视图配置
  final CalendarViewType viewType;    // 当前视图
  final bool showWeekNumber;          // 显示周数
  final bool showLunar;               // 显示农历
  final bool showHolidays;            // 显示节假日
  final bool showSolarTerms;          // 显示节气
  
  // 时间配置
  final int dayStartHour;             // 日视图起始时间
  final int dayEndHour;               // 日视图结束时间
  final int timeSlotMinutes;          // 时间槽分钟数
  
  // 交互配置
  final SelectionMode selectionMode;  // 选择模式
  final bool enableDrag;              // 允许拖拽
  final bool enableResize;            // 允许调整大小
  final bool enableCreate;            // 允许创建事件
  
  // 显示范围
  final DateTime? minDate;
  final DateTime? maxDate;
  final Set<DateTime>? disabledDates;
}

enum CalendarSystem { gregorian, lunar, islamic, hebrew }
enum CalendarViewType { year, month, week, day, agenda, timeline }
enum SelectionMode { none, single, multiple, range }
```

## 视图实现规范

### 月视图 (MonthView)

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
        // 周标题行
        WeekHeader(
          firstDayOfWeek: config.firstDayOfWeek,
          locale: config.locale,
        ),
        // 日期网格
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

/// 日期单元格
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
          // 公历日期
          Text(
            '${date.gregorian.day}',
            style: _getDateTextStyle(),
          ),
          // 农历日期 (可选)
          if (config.showLunar && date.lunar != null)
            Text(
              date.solarTerm ?? date.lunar!.dayChinese,
              style: _getLunarTextStyle(),
            ),
          // 事件指示器
          if (events.isNotEmpty)
            EventDots(events: events, maxDots: 3),
        ],
      ),
    );
  }
}
```

### 日视图 (DayView)

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
        // 时间网格背景
        SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            height: hourHeight * totalHours,
            child: Stack(
              children: [
                // 小时分隔线
                ...List.generate(totalHours, (i) => HourRow(
                  hour: widget.config.dayStartHour + i,
                  top: i * hourHeight,
                )),
                // 事件卡片
                ...widget.events.map((e) => Positioned(
                  top: _calculateTop(e.startTime),
                  left: 60,
                  right: 8,
                  height: _calculateHeight(e),
                  child: DraggableEventCard(event: e),
                )),
                // 当前时间指示线
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

### 周视图 (WeekView)

```dart
class WeekView extends StatelessWidget {
  final DateTime weekStart;
  final CalendarConfig config;
  final List<CalendarEvent> events;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 时间刻度列
        TimeRuler(
          startHour: config.dayStartHour,
          endHour: config.dayEndHour,
        ),
        // 7 天列
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

### 年度热力图 (YearHeatmap)

```dart
class YearHeatmap extends StatelessWidget {
  final int year;
  final Map<DateTime, int> data;      // 日期 -> 强度值
  final Color baseColor;
  final int maxValue;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 月份标签
        MonthLabels(year: year),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 周几标签
            WeekdayLabels(),
            // 热力图网格
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
        // 图例
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

## 交互功能实现

### 范围选择

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
      // 开始选择
      _startDate = date;
      _endDate = null;
      _isSelecting = true;
    } else {
      // 结束选择
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

### 拖拽事件

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
    // 计算新的时间位置
    final newDateTime = _calculateNewDateTime(_dragOffset);
    widget.onDragEnd(newDateTime);
    
    setState(() {
      _isDragging = false;
      _dragOffset = Offset.zero;
    });
  }
}
```

### 可调整大小

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
        // 事件卡片主体
        Container(
          height: _baseHeight + _extraHeight,
          decoration: BoxDecoration(
            color: widget.event.color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: EventCardContent(event: widget.event),
        ),
        // 底部调整手柄
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

## 业务场景实现

### 考勤日历

```dart
/// 考勤状态
enum AttendanceStatus {
  normal,       // 正常
  late,         // 迟到
  leaveEarly,   // 早退
  absent,       // 缺勤
  leave,        // 请假
  holiday,      // 节假日
  rest,         // 休息日
}

class AttendanceCalendar extends StatelessWidget {
  final Map<DateTime, AttendanceRecord> records;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 本月统计
        AttendanceStats(records: _currentMonthRecords),
        // 日历视图
        MonthView(
          month: _currentMonth,
          cellBuilder: (date) => AttendanceDayCell(
            date: date,
            record: records[date.dateOnly],
          ),
        ),
        // 图例
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

### 习惯追踪日历

```dart
class HabitCalendar extends StatelessWidget {
  final String habitId;
  final Map<DateTime, bool> completions;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 连续天数
        StreakDisplay(
          currentStreak: _calculateCurrentStreak(),
          longestStreak: _calculateLongestStreak(),
        ),
        // 本月完成率
        CompletionRate(
          completed: _monthCompletedDays,
          total: _monthTotalDays,
        ),
        // 热力图日历
        YearHeatmap(
          year: DateTime.now().year,
          data: completions.map((k, v) => MapEntry(k, v ? 1 : 0)),
          baseColor: Colors.green,
        ),
        // 月视图（可切换）
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

### 酒店价格日历

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
                '剩${priceInfo!.roomsLeft}间',
                style: TextStyle(fontSize: 8, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
```

### 农历日历

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
        suitable: lunar.suitable,   // 宜
        avoid: lunar.avoid,         // 忌
        conflictZodiac: lunar.conflictZodiac,  // 冲
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

## 设计规范

### 配色系统

```dart
class CalendarColors {
  // 主题色
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  
  // 日期颜色
  static const Color today = Color(0xFF2196F3);
  static const Color selected = Color(0xFF1976D2);
  static const Color inRange = Color(0xFFBBDEFB);
  static const Color weekend = Color(0xFFEF5350);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color holiday = Color(0xFFE91E63);
  
  // 事件颜色预设
  static const List<Color> eventColors = [
    Color(0xFF4CAF50),  // 绿
    Color(0xFF2196F3),  // 蓝
    Color(0xFFFF9800),  // 橙
    Color(0xFF9C27B0),  // 紫
    Color(0xFFE91E63),  // 粉
    Color(0xFF00BCD4),  // 青
    Color(0xFF795548),  // 棕
    Color(0xFF607D8B),  // 灰蓝
  ];
  
  // 热力图颜色
  static Color heatmapColor(double intensity, Color base) {
    return Color.lerp(
      base.withOpacity(0.1),
      base,
      intensity,
    )!;
  }
}
```

### 尺寸规范

```dart
class CalendarDimens {
  // 单元格
  static const double cellMinHeight = 40;
  static const double cellPadding = 4;
  static const double cellRadius = 8;
  
  // 事件
  static const double eventHeight = 20;
  static const double eventSpacing = 2;
  static const double eventRadius = 4;
  
  // 时间视图
  static const double hourHeight = 60;
  static const double timeColumnWidth = 56;
  static const double timeIndicatorHeight = 2;
  
  // 头部
  static const double headerHeight = 48;
  static const double weekHeaderHeight = 32;
  
  // 间距
  static const double viewPadding = 16;
  static const double sectionSpacing = 24;
}
```

### 动画规范

```dart
class CalendarAnimations {
  // 页面切换
  static const Duration pageSwitch = Duration(milliseconds: 300);
  static const Curve pageCurve = Curves.easeOutCubic;
  
  // 选择反馈
  static const Duration selection = Duration(milliseconds: 200);
  static const Curve selectionCurve = Curves.easeOut;
  
  // 拖拽
  static const Duration dragStart = Duration(milliseconds: 150);
  static const Duration dragEnd = Duration(milliseconds: 200);
  
  // 展开/折叠
  static const Duration expand = Duration(milliseconds: 250);
  static const Curve expandCurve = Curves.easeInOut;
  
  // 翻页日历
  static const Duration flip = Duration(milliseconds: 500);
  static const Curve flipCurve = Curves.easeInOutBack;
}
```

## 依赖项

```yaml
name: flutter_calendar_collection
description: 多样式日历组件库演示

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # 状态管理
  flutter_riverpod: ^2.4.9
  
  # 日期处理
  intl: ^0.18.1
  jiffy: ^6.2.1
  
  # 农历算法
  lunar: ^1.3.8
  
  # 本地存储
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # 动画
  flutter_animate: ^4.5.0
  
  # 图表 (热力图)
  fl_chart: ^0.66.0
  
  # UI 组件
  google_fonts: ^6.1.0
  flutter_slidable: ^3.0.1
  
  # 工具
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

## 实现优先级

### P0 - 核心基础

1. ✅ 项目结构
2. ✅ 核心数据模型
3. ✅ 公历日历系统
4. ✅ 月视图基础实现
5. ✅ 单选日期功能
6. ✅ 首页演示导航

### P1 - 视图完善

7. 周视图实现
8. 日视图实现
9. 年视图实现
10. 范围选择
11. 事件显示与管理
12. 农历支持

### P2 - 风格与交互

13. 热力图风格
14. 卡片风格
15. 圆形/环形风格
16. 翻页日历
17. 拖拽事件
18. 调整事件时长

### P3 - 业务场景

19. 考勤日历
20. 习惯追踪
21. 预约日历
22. 价格日历
23. 共享日历

### P4 - 增强功能

24. 伊斯兰历支持
25. 动画优化
26. 主题切换
27. 国际化
28. 性能优化

## 启动命令

```bash
# 获取依赖
flutter pub get

# 生成 Hive 适配器
flutter pub run build_runner build

# 运行
flutter run

# 构建
flutter build apk --release
```

## 注意事项

1. **农历算法**: `lunar` 包支持 1900-2100 年范围
2. **节假日数据**: 需定期更新，建议从服务器获取
3. **性能**: 年视图热力图数据量大，需虚拟化渲染
4. **时区**: 跨时区事件需特殊处理
5. **无障碍**: 为日期单元格添加语义标签
6. **测试**: 注意闰年、月末、跨年等边界情况
