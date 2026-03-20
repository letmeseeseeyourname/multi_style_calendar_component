import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];

  bool get isChinese => locale.languageCode == 'zh';

  // ====== Common ======
  String get appTitle => isChinese ? '多样式日历组件库' : 'Multi-Style Calendar';
  String get appHeaderTitle => isChinese ? 'Flutter 多样式日历' : 'Flutter Multi-Style Calendar';
  String get appHeaderSubtitle => isChinese ? '涵盖多种历法、视图、交互与业务场景' : 'Multiple calendars, views, interactions & scenarios';
  String get cancel => isChinese ? '取消' : 'Cancel';
  String get confirm => isChinese ? '确定' : 'OK';
  String get save => isChinese ? '保存' : 'Save';
  String get delete_ => isChinese ? '删除' : 'Delete';
  String get edit => isChinese ? '编辑' : 'Edit';
  String get clear => isChinese ? '清空' : 'Clear';
  String get today => isChinese ? '今天' : 'Today';
  String get tomorrow => isChinese ? '明天' : 'Tomorrow';
  String get yesterday => isChinese ? '昨天' : 'Yesterday';
  String get noData => isChinese ? '暂无数据' : 'No data';
  String get previous => isChinese ? '上一页' : 'Previous';
  String get next => isChinese ? '下一页' : 'Next';
  String get on_ => isChinese ? '开' : 'On';
  String get off_ => isChinese ? '关' : 'Off';
  String get allDay => isChinese ? '全天' : 'All day';
  String get now => isChinese ? '现在' : 'Now';

  // ====== Date format helpers ======
  String get yearSuffix => isChinese ? '年' : '';
  String get monthSuffix => isChinese ? '月' : '';
  String get daySuffix => isChinese ? '日' : '';
  String get daySuffixUnit => isChinese ? '天' : 'd';
  String get hourSuffix => isChinese ? '小时' : 'h';
  String get minuteSuffix => isChinese ? '分钟' : 'min';
  String get nightUnit => isChinese ? '晚' : 'night(s)';
  String get itemUnit => isChinese ? '项' : 'items';
  String get timesUnit => isChinese ? '次' : 'times';
  String get roomUnit => isChinese ? '间' : 'room(s)';

  String yearMonth(int year, int month) {
    return isChinese ? '$year年$month月' : '$year-${month.toString().padLeft(2, '0')}';
  }

  String yearMonthDay(int year, int month, int day) {
    return isChinese
        ? '$year年$month月$day日'
        : '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  String monthDay(int month, int day) {
    return isChinese ? '$month月$day日' : '${month.toString().padLeft(2, '0')}/$day';
  }

  String nDays(int n) => isChinese ? '$n天' : '$n day${n > 1 ? 's' : ''}';
  String nItems(int n) => isChinese ? '$n 项' : '$n item${n > 1 ? 's' : ''}';
  String nActivities(int n) => isChinese ? '$n 次活动' : '$n activit${n > 1 ? 'ies' : 'y'}';
  String nSelected(int n) => isChinese ? '已选 $n 个日期' : '$n date${n > 1 ? 's' : ''} selected';

  String durationText(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remaining = minutes % 60;
      if (isChinese) {
        return remaining > 0 ? '$hours小时${remaining}分钟' : '$hours小时';
      } else {
        return remaining > 0 ? '${hours}h ${remaining}min' : '${hours}h';
      }
    }
    return isChinese ? '$minutes分钟' : '${minutes}min';
  }

  // ====== Month names ======
  List<String> get monthNames => isChinese
      ? const ['', '一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
      : const ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  List<String> get monthNamesShort => isChinese
      ? const ['', '1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
      : const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  String monthName(int month) => monthNames[month];

  // ====== Weekday names ======
  List<String> get weekdayNamesShort => isChinese
      ? const ['一', '二', '三', '四', '五', '六', '日']
      : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<String> get weekdayNamesLong => isChinese
      ? const ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
      : const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  String weekdayShort(int weekday) => weekdayNamesShort[(weekday - 1) % 7];
  String weekdayLong(int weekday) => weekdayNamesLong[(weekday - 1) % 7];

  // ====== Home Screen ======
  String get viewModes => isChinese ? '视图模式' : 'View Modes';
  String get viewModesSubtitle => isChinese ? '年 / 月 / 周 / 日 / 日程 / 时间线' : 'Year / Month / Week / Day / Agenda / Timeline';
  String get visualStyles => isChinese ? '视觉风格' : 'Visual Styles';
  String get visualStylesSubtitle => isChinese ? '经典 / 卡片 / 圆形 / 热力图 / 翻页 / 极简 / 毛玻璃' : 'Classic / Card / Circular / Heatmap / Flip / Minimal / Glass';
  String get datePickers => isChinese ? '日期选择器' : 'Date Pickers';
  String get datePickersSubtitle => isChinese ? '单选 / 多选 / 范围 / 月份 / 年份 / 日期时间' : 'Single / Multi / Range / Month / Year / DateTime';
  String get businessScenarios => isChinese ? '业务场景' : 'Business Scenarios';
  String get businessScenariosSubtitle => isChinese ? '考勤 / 习惯 / 预约 / 价格 / 农历 / 倒计时 / 共享' : 'Attendance / Habit / Booking / Pricing / Lunar / Countdown / Shared';
  String get playground => isChinese ? '自由配置' : 'Playground';
  String get playgroundSubtitle => isChinese ? '自定义日历参数与交互' : 'Customize calendar parameters & interaction';

  // ====== View Tabs ======
  String get monthView => isChinese ? '月视图' : 'Month';
  String get weekView => isChinese ? '周视图' : 'Week';
  String get dayView => isChinese ? '日视图' : 'Day';
  String get yearView => isChinese ? '年视图' : 'Year';
  String get agendaView => isChinese ? '日程列表' : 'Agenda';
  String get timelineView => isChinese ? '时间线' : 'Timeline';
  String get scrollPicker => isChinese ? '滚动选择' : 'Scroll Picker';

  // ====== Style Tabs ======
  String get classicGrid => isChinese ? '经典网格' : 'Classic Grid';
  String get cardStyle => isChinese ? '卡片式' : 'Card';
  String get circular => isChinese ? '圆形' : 'Circular';
  String get heatmap => isChinese ? '热力图' : 'Heatmap';
  String get flip => isChinese ? '翻页' : 'Flip';
  String get minimal => isChinese ? '极简' : 'Minimal';
  String get glassmorphism => isChinese ? '毛玻璃' : 'Glass';
  String get more => isChinese ? '更多' : 'More';
  String get circularWeekView => isChinese ? '圆形周视图' : 'Circular Week View';
  String get ringMonthView => isChinese ? '环形月视图' : 'Ring Month View';
  String get clockDayView => isChinese ? '时钟式日视图' : 'Clock Day View';
  String get githubHeatmap => isChinese ? 'GitHub 风格热力图' : 'GitHub-Style Heatmap';
  String get activityHeatmap => isChinese ? '活动热力图' : 'Activity Heatmap';

  // ====== Picker ======
  String get tapToShowPicker => isChinese ? '点击按钮查看选择器' : 'Tap a button to show picker';
  String resultLabel(String result) => isChinese ? '选择结果: $result' : 'Result: $result';
  String get singleDate => isChinese ? '单选日期' : 'Single Date';
  String get multiDate => isChinese ? '多选日期' : 'Multi Date';
  String get rangeSelect => isChinese ? '范围选择' : 'Range Select';
  String get monthSelect => isChinese ? '月份选择' : 'Month Select';
  String get yearSelect => isChinese ? '年份选择' : 'Year Select';
  String get dateTimeSelect => isChinese ? '日期时间选择' : 'Date & Time';
  String get selectDate => isChinese ? '选择日期' : 'Select Date';
  String get selectMultiDates => isChinese ? '选择多个日期' : 'Select Multiple Dates';
  String selectedCount(int n) => isChinese ? '已选择 $n 天' : '$n day${n > 1 ? 's' : ''} selected';
  String get selectRange => isChinese ? '选择日期范围' : 'Select Date Range';
  String get selectStartDate => isChinese ? '选择开始日期' : 'Select start date';
  String selectEndDate(int days) => isChinese ? ' - 选择结束日期 ($days天)' : ' - Select end date ($days day${days > 1 ? 's' : ''})';
  String get selectMonth => isChinese ? '选择月份' : 'Select Month';
  String get selectYear => isChinese ? '选择年份' : 'Select Year';
  String get selectDateTime => isChinese ? '选择日期和时间' : 'Select Date & Time';
  String get notSelected => isChinese ? '未选择' : 'Not selected';
  String get date => isChinese ? '日期' : 'Date';
  String get time => isChinese ? '时间' : 'Time';

  // ====== Event Form ======
  String get editEvent => isChinese ? '编辑事件' : 'Edit Event';
  String get newEvent => isChinese ? '新建事件' : 'New Event';
  String get title_ => isChinese ? '标题' : 'Title';
  String get enterTitle => isChinese ? '输入事件标题' : 'Enter event title';
  String get titleRequired => isChinese ? '请输入事件标题' : 'Title is required';
  String get allDayEvent => isChinese ? '全天事件' : 'All-day event';
  String get start => isChinese ? '开始' : 'Start';
  String get end => isChinese ? '结束' : 'End';
  String get endBeforeStart => isChinese ? '结束时间不能早于开始时间' : 'End time cannot be before start time';
  String get location => isChinese ? '地点' : 'Location';
  String get enterLocation => isChinese ? '输入地点（可选）' : 'Enter location (optional)';
  String get description => isChinese ? '描述' : 'Description';
  String get enterDescription => isChinese ? '输入事件描述（可选）' : 'Enter description (optional)';
  String get color => isChinese ? '颜色' : 'Color';
  String get saveChanges => isChinese ? '保存修改' : 'Save Changes';
  String get createEvent => isChinese ? '创建事件' : 'Create Event';

  // ====== Playground ======
  String get configuration => isChinese ? '配置' : 'Settings';
  String get showLunar => isChinese ? '显示农历' : 'Show Lunar';
  String get highlightWeekend => isChinese ? '周末标红' : 'Highlight Weekend';
  String get weekStartDay => isChinese ? '周起始日' : 'Week Starts';
  String get monday => isChinese ? '周一' : 'Mon';
  String get sunday => isChinese ? '周日' : 'Sun';
  String get selectionMode => isChinese ? '选择模式' : 'Selection Mode';
  String get lunarLabel => isChinese ? '农历' : 'Lunar';
  String get startLabel => isChinese ? '起始' : 'Start';
  String selectedLabel(String date) => isChinese ? '已选: $date' : 'Selected: $date';
  String startingFrom(String date) => isChinese ? '起始: $date' : 'From: $date';

  // ====== Business: Attendance ======
  String get attendance => isChinese ? '考勤' : 'Attendance';
  String get normal => isChinese ? '正常' : 'Normal';
  String get late_ => isChinese ? '迟到' : 'Late';
  String get leaveEarly => isChinese ? '早退' : 'Left Early';
  String get absent => isChinese ? '缺勤' : 'Absent';
  String get onLeave => isChinese ? '请假' : 'On Leave';
  String get holiday => isChinese ? '节假日' : 'Holiday';
  String get restDay => isChinese ? '休息日' : 'Rest Day';
  String get notClocked => isChinese ? '未打卡' : 'Not clocked';
  String get annualLeave => isChinese ? '年假' : 'Annual leave';
  String attendanceStatsTitle(int month) => isChinese ? '$month月考勤统计' : 'Attendance Stats for Month $month';
  String get attendanceDays => isChinese ? '出勤' : 'Present';
  String get attendanceRate => isChinese ? '出勤率' : 'Rate';
  String get checkIn => isChinese ? '签到' : 'Check-in';
  String get checkOut => isChinese ? '签退' : 'Check-out';
  String get remark => isChinese ? '备注' : 'Note';
  String noAttendanceRecord(int month, int day) => isChinese ? '$month月$day日 - 无考勤记录' : '$month/$day - No record';

  // ====== Business: Habit ======
  String get habitTracker => isChinese ? '习惯追踪' : 'Habit Tracker';
  String get currentStreak => isChinese ? '当前连续' : 'Current Streak';
  String get longestStreak => isChinese ? '最长连续' : 'Longest Streak';
  String get totalCheckins => isChinese ? '总打卡' : 'Total';
  String completionRate(int month) => isChinese ? '$month月完成率' : 'Month $month Completion';

  // ====== Business: Booking ======
  String get booking => isChinese ? '预约' : 'Booking';
  String get bookingManagement => isChinese ? '预约管理' : 'Booking Management';
  String get selectDateForSlots => isChinese ? '选择日期查看可用时间段' : 'Select a date to view available slots';
  String get monthlyBookings => isChinese ? '本月预约' : 'This Month';
  String get available => isChinese ? '可选' : 'Available';
  String get selected => isChinese ? '已选' : 'Selected';
  String get booked => isChinese ? '已预约' : 'Booked';
  String get unavailable => isChinese ? '不可用' : 'Unavailable';
  String get confirmBooking => isChinese ? '确认预约' : 'Confirm Booking';
  String get weeklyAvailability => isChinese ? '本周可用时间' : 'Weekly Availability';
  String availableSlots(int n) => isChinese ? '${n}可约' : '$n available';
  String availableTimeTitle(int month, int day) => isChinese ? '$month月$day日 可用时间' : '$month/$day Available Time';
  String bookedSlot(String time) => isChinese ? '已预约 $time' : 'Booked: $time';
  String get selectedSlotLabel => isChinese ? '已选择: ' : 'Selected: ';

  // ====== Business: Hotel Pricing ======
  String get hotelPricing => isChinese ? '酒店价格' : 'Hotel Pricing';
  String get selectCheckInDate => isChinese ? '请选择入住日期' : 'Select check-in date';
  String get selectCheckOutDate => isChinese ? '请选择退房日期' : 'Select check-out date';
  String get checkInLabel => isChinese ? '入住' : 'Check-in';
  String get checkOutLabel => isChinese ? '退房' : 'Check-out';
  String roomsLeft(int n) => isChinese ? '剩${n}间' : '$n left';
  String nightsTotal(int n) => isChinese ? '$n晚 共' : '$n night${n > 1 ? 's' : ''} total';
  String get perNight => isChinese ? '/晚' : '/night';
  String get soldOut => isChinese ? '已满' : 'Sold out';
  String get special => isChinese ? '特惠' : 'Special';
  String get normal_ => isChinese ? '平日' : 'Normal';
  String get peakSeason => isChinese ? '旺季' : 'Peak';
  String get highPeak => isChinese ? '高峰' : 'High Peak';
  String roomTypeTitle(int month, int day) => isChinese ? '$month月$day日 房型' : '$month/$day Room Types';
  String roomsAvailable(int n) => isChinese ? '剩余${n}间' : '$n available';
  String roomsLow(int n) => isChinese ? '仅剩${n}间' : 'Only $n left';

  // ====== Business: Lunar Calendar ======
  String get lunarCalendar => isChinese ? '农历日历' : 'Lunar Calendar';
  String get lunarLabel2 => isChinese ? '农历' : 'Lunar';
  String get ganZhi => isChinese ? '干支' : 'GanZhi';
  String get zodiac => isChinese ? '生肖' : 'Zodiac';
  String get solarTerm => isChinese ? '节气' : 'Solar Term';
  String get festival => isChinese ? '节日' : 'Festival';
  String get festivalAndSolarTerm => isChinese ? '节日/节气' : 'Festivals / Solar Terms';
  String get lunarFestival => isChinese ? '农历节日' : 'Lunar Festival';
  String get gregorianHoliday => isChinese ? '公历节日' : 'Holiday';
  String get suitable => isChinese ? '宜' : 'Suitable';
  String get avoid => isChinese ? '忌' : 'Avoid';
  String fortuneTitle(int month, int day) => isChinese ? '$month月$day日 宜忌' : '$month/$day Fortune';

  // ====== Business: Countdown ======
  String get countdown => isChinese ? '倒计时' : 'Countdown';
  String get targetCountdown => isChinese ? '目标倒计时' : 'Target Countdown';
  String daysPassed(int n) => isChinese ? '已过 $n 天' : '$n day${n > 1 ? 's' : ''} passed';
  String daysRemaining(int n) => isChinese ? '距目标还有 $n 天' : '$n day${n > 1 ? 's' : ''} remaining';
  String get target => isChinese ? '目标' : 'Target';
  String get milestone => isChinese ? '里程碑' : 'Milestones';
  String get passed => isChinese ? '已过' : 'Passed';
  String get completed => isChinese ? '已完成' : 'Completed';

  // ====== Business: Shared Calendar ======
  String get sharedCalendar => isChinese ? '共享日历' : 'Shared Calendar';
  String get memberCalendar => isChinese ? '成员日历' : 'Member Calendar';
  String get noEvents => isChinese ? '暂无日程' : 'No events';
  String get noSchedule => isChinese ? '暂无日程安排' : 'No upcoming events';
  String get noEventsShort => isChinese ? '无日程' : 'None';
  String get attendees => isChinese ? '参与者: ' : 'Attendees: ';
  String daySchedule(int month, int day) => isChinese ? '$month月$day日 日程' : '$month/$day Schedule';
  String conflictText(String a, String b, String overlap, String members) =>
      isChinese ? '$a 与 $b 冲突 ($overlap, $members)' : '$a conflicts with $b ($overlap, $members)';

  // ====== Business: Period Tracker ======
  String get periodTracker => isChinese ? '经期追踪' : 'Period Tracker';
  String daysUntilPeriod(int n) => isChinese ? '距下次经期还有 $n 天' : '$n day${n > 1 ? 's' : ''} until next period';
  String get expectedToday => isChinese ? '预计今天开始' : 'Expected to start today';
  String get periodOngoing => isChinese ? '经期进行中' : 'Period ongoing';
  String get averageCycle => isChinese ? '平均周期' : 'Avg. Cycle';
  String get period => isChinese ? '经期' : 'Period';
  String get predictedPeriod => isChinese ? '预测经期' : 'Predicted';
  String get fertileWindow => isChinese ? '易孕期' : 'Fertile';
  String get ovulationDay => isChinese ? '排卵日' : 'Ovulation';
  String symptomTitle(int month, int day) => isChinese ? '$month月$day日 症状记录' : '$month/$day Symptom Log';
  String get adjustSeverity => isChinese ? '调整严重程度' : 'Adjust severity';

  // ====== Symptom names ======
  String get cramps => isChinese ? '痛经' : 'Cramps';
  String get headache => isChinese ? '头痛' : 'Headache';
  String get bloating => isChinese ? '腹胀' : 'Bloating';
  String get fatigue => isChinese ? '疲劳' : 'Fatigue';
  String get moodSwings => isChinese ? '情绪波动' : 'Mood Swings';
  String get backPain => isChinese ? '腰痛' : 'Back Pain';
  String get nausea => isChinese ? '恶心' : 'Nausea';
  String get acne => isChinese ? '痘痘' : 'Acne';
  String get insomnia => isChinese ? '失眠' : 'Insomnia';
  String get appetiteChange => isChinese ? '食欲变化' : 'Appetite Change';

  // ====== Severity ======
  String get mild => isChinese ? '轻微' : 'Mild';
  String get moderate => isChinese ? '中等' : 'Moderate';
  String get severe => isChinese ? '严重' : 'Severe';

  // ====== Heatmap / Stats ======
  String get less => isChinese ? '少' : 'Less';
  String get more_ => isChinese ? '多' : 'More';
  String get total => isChinese ? '总计' : 'Total';
  String get activeDays => isChinese ? '活跃天' : 'Active Days';
  String yearActivityTitle(int year) => isChinese ? '$year 年活动记录' : '$year Activity';
  String totalActivities(int n) => isChinese ? '共 $n 次活动' : '$n total activities';
  String dayActivityTooltip(int month, int day, int value) =>
      isChinese ? '$month月$day日: $value 次活动' : '$month/$day: $value activit${value > 1 ? 'ies' : 'y'}';
  String dayData(int n) => isChinese ? '$n 天活动数据' : '$n days of data';

  // ====== Agenda ======
  String get category => isChinese ? '分类' : 'Category';
  String get default_ => isChinese ? '默认' : 'Default';
  String weekNumber(int n) => isChinese ? '第 $n 周' : 'Week $n';
  String nEvents(int n) => isChinese ? '$n 事件' : '$n event${n > 1 ? 's' : ''}';

  // ====== Scroll Picker ======
  String get confirmSelection => isChinese ? '确认' : 'Confirm';

  // ====== View Switcher labels ======
  String get yearLabel => isChinese ? '年' : 'Year';
  String get monthLabel => isChinese ? '月' : 'Month';
  String get weekLabel => isChinese ? '周' : 'Week';
  String get dayLabel => isChinese ? '日' : 'Day';
  String get agendaLabel => isChinese ? '日程' : 'Agenda';
  String get timelineLabel => isChinese ? '时间线' : 'Timeline';

  // ====== Countdown milestone mock data ======
  String get projectDelivery => isChinese ? '项目交付' : 'Project Delivery';
  String get v1Release => isChinese ? 'V1.0 版本发布' : 'V1.0 Release';
  String get yearEndReview => isChinese ? '年终考核' : 'Year-End Review';
  String get prepareReport => isChinese ? '准备述职报告' : 'Prepare report';
  String get vacationStart => isChinese ? '假期出发' : 'Vacation Start';
  String get tokyoTrip => isChinese ? '东京旅行' : 'Tokyo Trip';
  String get birthday => isChinese ? '生日' : 'Birthday';
  String get pastEvent => isChinese ? '过去的事件' : 'Past Event';

  // ====== Shared calendar mock data ======
  String get teamWeekly => isChinese ? '团队周会' : 'Team Weekly';
  String get projectReview => isChinese ? '项目评审' : 'Project Review';
  String get requirementDiscussion => isChinese ? '产品需求讨论' : 'Requirement Discussion';
  String get oneOnOne => isChinese ? '1对1沟通' : '1-on-1 Meeting';
  String get codeReview => isChinese ? '代码评审' : 'Code Review';
  String get teamBuilding => isChinese ? '团建活动' : 'Team Building';
  String get techSharing => isChinese ? '技术分享' : 'Tech Sharing';
  String get meetingRoomA => isChinese ? '会议室A' : 'Room A';
  String get meetingRoomB => isChinese ? '会议室B' : 'Room B';
  String get outdoorVenue => isChinese ? '户外拓展基地' : 'Outdoor Venue';

  // ====== Room types ======
  String get standardRoom => isChinese ? '标准大床房' : 'Standard King Room';
  String get standardRoomDesc => isChinese ? '1.8m大床 / 25m² / 含早' : '1.8m King Bed / 25m² / Breakfast';
  String get deluxeTwinRoom => isChinese ? '豪华双床房' : 'Deluxe Twin Room';
  String get deluxeTwinRoomDesc => isChinese ? '2×1.2m单人床 / 30m² / 含早' : '2×1.2m Beds / 30m² / Breakfast';
  String get executiveSuite => isChinese ? '行政套房' : 'Executive Suite';
  String get executiveSuiteDesc => isChinese ? '1.8m大床 / 45m² / 行政酒廊' : '1.8m King / 45m² / Lounge';
  String get presidentialSuite => isChinese ? '总统套房' : 'Presidential Suite';
  String get presidentialSuiteDesc => isChinese ? '2.0m大床 / 80m² / 全景' : '2.0m King / 80m² / Panoramic';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
