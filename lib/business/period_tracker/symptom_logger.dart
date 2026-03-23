import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// 症状类型
enum SymptomType {
  cramps, // 痛经
  headache, // 头痛
  bloating, // 腹胀
  fatigue, // 疲劳
  moodSwings, // 情绪波动
  backPain, // 腰痛
  nausea, // 恶心
  acne, // 痘痘
  insomnia, // 失眠
  appetite, // 食欲变化
}

extension SymptomTypeExtension on SymptomType {
  String get label => localizedLabel(null);

  String localizedLabel(AppLocalizations? l) {
    if (l != null) {
      switch (this) {
        case SymptomType.cramps:
          return l.cramps;
        case SymptomType.headache:
          return l.headache;
        case SymptomType.bloating:
          return l.bloating;
        case SymptomType.fatigue:
          return l.fatigue;
        case SymptomType.moodSwings:
          return l.moodSwings;
        case SymptomType.backPain:
          return l.backPain;
        case SymptomType.nausea:
          return l.nausea;
        case SymptomType.acne:
          return l.acne;
        case SymptomType.insomnia:
          return l.insomnia;
        case SymptomType.appetite:
          return l.appetiteChange;
      }
    }
    switch (this) {
      case SymptomType.cramps:
        return '痛经';
      case SymptomType.headache:
        return '头痛';
      case SymptomType.bloating:
        return '腹胀';
      case SymptomType.fatigue:
        return '疲劳';
      case SymptomType.moodSwings:
        return '情绪波动';
      case SymptomType.backPain:
        return '腰痛';
      case SymptomType.nausea:
        return '恶心';
      case SymptomType.acne:
        return '痘痘';
      case SymptomType.insomnia:
        return '失眠';
      case SymptomType.appetite:
        return '食欲变化';
    }
  }

  IconData get icon {
    switch (this) {
      case SymptomType.cramps:
        return Icons.flash_on;
      case SymptomType.headache:
        return Icons.psychology;
      case SymptomType.bloating:
        return Icons.bubble_chart;
      case SymptomType.fatigue:
        return Icons.battery_alert;
      case SymptomType.moodSwings:
        return Icons.mood;
      case SymptomType.backPain:
        return Icons.accessibility_new;
      case SymptomType.nausea:
        return Icons.sick;
      case SymptomType.acne:
        return Icons.face;
      case SymptomType.insomnia:
        return Icons.nightlight;
      case SymptomType.appetite:
        return Icons.restaurant;
    }
  }
}

/// 症状严重程度
enum SymptomSeverity { mild, moderate, severe }

extension SymptomSeverityExtension on SymptomSeverity {
  String get label => localizedLabel(null);

  String localizedLabel(AppLocalizations? l) {
    if (l != null) {
      switch (this) {
        case SymptomSeverity.mild:
          return l.mild;
        case SymptomSeverity.moderate:
          return l.moderate;
        case SymptomSeverity.severe:
          return l.severe;
      }
    }
    switch (this) {
      case SymptomSeverity.mild:
        return '轻微';
      case SymptomSeverity.moderate:
        return '中等';
      case SymptomSeverity.severe:
        return '严重';
    }
  }

  Color get color {
    switch (this) {
      case SymptomSeverity.mild:
        return const Color(0xFF81C784);
      case SymptomSeverity.moderate:
        return const Color(0xFFFFB74D);
      case SymptomSeverity.severe:
        return const Color(0xFFE57373);
    }
  }
}

/// 症状记录
class SymptomEntry {
  final SymptomType type;
  final SymptomSeverity severity;

  const SymptomEntry({required this.type, required this.severity});
}

/// 症状记录组件
class SymptomLogger extends StatefulWidget {
  final DateTime date;
  final List<SymptomEntry> initialSymptoms;
  final ValueChanged<List<SymptomEntry>>? onSymptomsChanged;

  const SymptomLogger({
    super.key,
    required this.date,
    this.initialSymptoms = const [],
    this.onSymptomsChanged,
  });

  @override
  State<SymptomLogger> createState() => _SymptomLoggerState();
}

class _SymptomLoggerState extends State<SymptomLogger> {
  late Map<SymptomType, SymptomSeverity?> _selectedSymptoms;

  @override
  void initState() {
    super.initState();
    _selectedSymptoms = {};
    for (final entry in widget.initialSymptoms) {
      _selectedSymptoms[entry.type] = entry.severity;
    }
  }

  void _toggleSymptom(SymptomType type) {
    setState(() {
      if (_selectedSymptoms.containsKey(type)) {
        _selectedSymptoms.remove(type);
      } else {
        _selectedSymptoms[type] = SymptomSeverity.moderate;
      }
      _notifyChange();
    });
  }

  void _setSeverity(SymptomType type, SymptomSeverity severity) {
    setState(() {
      _selectedSymptoms[type] = severity;
      _notifyChange();
    });
  }

  void _notifyChange() {
    widget.onSymptomsChanged?.call(
      _selectedSymptoms.entries
          .map((e) => SymptomEntry(type: e.key, severity: e.value!))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.symptomTitle(widget.date.month, widget.date.day),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SymptomType.values.map((type) {
              final isSelected = _selectedSymptoms.containsKey(type);
              final severity = _selectedSymptoms[type];

              return GestureDetector(
                onTap: () => _toggleSymptom(type),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (severity?.color ?? Colors.grey).withValues(
                            alpha: 0.15,
                          )
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? (severity?.color ?? Colors.grey)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type.icon,
                        size: 16,
                        color: isSelected ? severity?.color : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        type.localizedLabel(l),
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          // Severity selector for selected symptoms
          if (_selectedSymptoms.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              l.adjustSeverity,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ..._selectedSymptoms.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        entry.key.localizedLabel(l),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    ...SymptomSeverity.values.map((severity) {
                      final isActive = entry.value == severity;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => _setSeverity(entry.key, severity),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? severity.color.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? severity.color
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              severity.localizedLabel(l),
                              style: TextStyle(
                                fontSize: 12,
                                color: isActive ? severity.color : Colors.grey,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
