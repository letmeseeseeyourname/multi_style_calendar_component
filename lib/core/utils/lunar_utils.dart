import 'package:lunar/lunar.dart';

/// 农历工具
class LunarUtils {
  LunarUtils._();

  static Lunar fromDate(DateTime date) {
    final solar = Solar.fromDate(date);
    return solar.getLunar();
  }

  static String getLunarDayText(DateTime date) {
    final lunar = fromDate(date);
    final jieQi = lunar.getCurrentJieQi();
    if (jieQi != null) return jieQi.getName();

    final festivals = lunar.getFestivals();
    if (festivals.isNotEmpty) return festivals.first;

    return lunar.getDayInChinese();
  }

  static String getZodiac(int lunarYear) {
    final lunar = Lunar.fromYmd(lunarYear, 1, 1);
    return lunar.getYearShengXiao();
  }

  static String getGanZhiYear(int lunarYear) {
    final lunar = Lunar.fromYmd(lunarYear, 1, 1);
    return lunar.getYearInGanZhi();
  }

  static List<String> getSuitable(DateTime date) {
    final lunar = fromDate(date);
    return lunar.getDayYi();
  }

  static List<String> getAvoid(DateTime date) {
    final lunar = fromDate(date);
    return lunar.getDayJi();
  }
}
