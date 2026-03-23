import 'package:flutter/material.dart';
import '../../../core/utils/lunar_utils.dart';
import '../../../l10n/app_localizations.dart';

/// 每日宜忌展示组件
class FortuneDisplay extends StatelessWidget {
  final DateTime date;

  const FortuneDisplay({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final suitable = LunarUtils.getSuitable(date);
    final avoid = LunarUtils.getAvoid(date);

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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: Color(0xFFD32F2F),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l.fortuneTitle(date.month, date.day),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Suitable (宜)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  l.suitable,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      (suitable.isNotEmpty
                              ? suitable.take(8).toList()
                              : [l.noData])
                          .map(
                            (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF4CAF50,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Avoid (忌)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF44336),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  l.avoid,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      (avoid.isNotEmpty ? avoid.take(8).toList() : [l.noData])
                          .map(
                            (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF44336,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFC62828),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
