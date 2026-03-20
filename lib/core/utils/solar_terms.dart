import 'package:lunar/lunar.dart';

/// 二十四节气工具
class SolarTermsUtils {
  SolarTermsUtils._();

  static const List<String> solarTerms = [
    '小寒', '大寒', '立春', '雨水', '惊蛰', '春分',
    '清明', '谷雨', '立夏', '小满', '芒种', '夏至',
    '小暑', '大暑', '立秋', '处暑', '白露', '秋分',
    '寒露', '霜降', '立冬', '小雪', '大雪', '冬至',
  ];

  static String? getSolarTerm(DateTime date) {
    final solar = Solar.fromDate(date);
    final lunar = solar.getLunar();
    final jieQi = lunar.getCurrentJieQi();
    return jieQi?.getName();
  }

  static Map<String, DateTime> getSolarTermsInYear(int year) {
    final result = <String, DateTime>{};
    for (int month = 1; month <= 12; month++) {
      for (int day = 1; day <= DateTime(year, month + 1, 0).day; day++) {
        final date = DateTime(year, month, day);
        final term = getSolarTerm(date);
        if (term != null && !result.containsKey(term)) {
          result[term] = date;
        }
      }
    }
    return result;
  }
}
