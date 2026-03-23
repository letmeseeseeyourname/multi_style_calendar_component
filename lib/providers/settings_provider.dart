import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/calendar_config.dart';

final showLunarProvider = StateProvider<bool>((ref) => true);
final showHolidaysProvider = StateProvider<bool>((ref) => true);
final firstDayOfWeekProvider = StateProvider<int>((ref) => 1);
final selectionModeProvider = StateProvider<SelectionMode>(
  (ref) => SelectionMode.single,
);
final localeProvider = StateProvider<Locale>((ref) => const Locale('zh', 'CN'));
