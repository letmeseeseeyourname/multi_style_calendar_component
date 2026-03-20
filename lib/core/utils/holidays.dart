/// 节假日数据
class HolidayData {
  final String name;
  final bool isHoliday;

  const HolidayData({required this.name, this.isHoliday = true});
}

class Holidays {
  Holidays._();

  static final Map<String, HolidayData> _cnHolidays = {
    '01-01': const HolidayData(name: '元旦'),
    '02-14': const HolidayData(name: '情人节', isHoliday: false),
    '03-08': const HolidayData(name: '妇女节', isHoliday: false),
    '04-05': const HolidayData(name: '清明节'),
    '05-01': const HolidayData(name: '劳动节'),
    '05-04': const HolidayData(name: '青年节', isHoliday: false),
    '06-01': const HolidayData(name: '儿童节', isHoliday: false),
    '10-01': const HolidayData(name: '国庆节'),
    '12-25': const HolidayData(name: '圣诞节', isHoliday: false),
  };

  static HolidayData? getHoliday(DateTime date) {
    final key =
        '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _cnHolidays[key];
  }

  static bool isHoliday(DateTime date) {
    final h = getHoliday(date);
    return h?.isHoliday ?? false;
  }

  static String? getHolidayName(DateTime date) {
    return getHoliday(date)?.name;
  }
}
