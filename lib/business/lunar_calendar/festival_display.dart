import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

/// 节日信息展示组件
class FestivalDisplay extends StatelessWidget {
  final String? solarTerm;
  final String? lunarFestival;
  final String? gregorianHoliday;
  final DateTime date;

  const FestivalDisplay({
    super.key,
    this.solarTerm,
    this.lunarFestival,
    this.gregorianHoliday,
    required this.date,
  });

  bool get hasFestival =>
      solarTerm != null || lunarFestival != null || gregorianHoliday != null;

  @override
  Widget build(BuildContext context) {
    if (!hasFestival) return const SizedBox.shrink();

    final l = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD32F2F).withValues(alpha: 0.08),
            const Color(0xFFFF5722).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.celebration, color: Color(0xFFD32F2F), size: 20),
              const SizedBox(width: 8),
              Text(
                l.festivalAndSolarTerm,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (lunarFestival != null)
            _FestivalItem(
              icon: Icons.auto_awesome,
              label: l.lunarFestival,
              value: lunarFestival!,
              color: const Color(0xFFD32F2F),
            ),
          if (solarTerm != null)
            _FestivalItem(
              icon: Icons.eco,
              label: l.solarTerm,
              value: solarTerm!,
              color: const Color(0xFF4CAF50),
            ),
          if (gregorianHoliday != null)
            _FestivalItem(
              icon: Icons.flag,
              label: l.gregorianHoliday,
              value: gregorianHoliday!,
              color: const Color(0xFF2196F3),
            ),
        ],
      ),
    );
  }
}

class _FestivalItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _FestivalItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
