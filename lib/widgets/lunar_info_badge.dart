import 'package:flutter/material.dart';

import '../core/utils/lunar_utils.dart';

/// A small badge showing lunar date information (lunar day text, solar term, festival).
class LunarInfoBadge extends StatelessWidget {
  /// The Gregorian date for which to display lunar info.
  final DateTime date;

  /// Text style override for the badge text.
  final TextStyle? textStyle;

  /// Background color override.
  final Color? backgroundColor;

  /// Whether to show as a chip with background, or plain text.
  final bool showBackground;

  /// Maximum width constraint.
  final double? maxWidth;

  const LunarInfoBadge({
    super.key,
    required this.date,
    this.textStyle,
    this.backgroundColor,
    this.showBackground = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final lunarText = LunarUtils.getLunarDayText(date);
    final lunar = LunarUtils.fromDate(date);

    // Determine if this is a special day (solar term or festival)
    final jieQi = lunar.getCurrentJieQi();
    final festivals = lunar.getFestivals();
    final isSpecial = jieQi != null || festivals.isNotEmpty;

    final effectiveTextStyle = textStyle ??
        theme.textTheme.labelSmall?.copyWith(
          fontSize: 10,
          color: isSpecial ? colorScheme.error : colorScheme.onSurfaceVariant,
          fontWeight: isSpecial ? FontWeight.w600 : FontWeight.normal,
        );

    final content = Text(
      lunarText,
      style: effectiveTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (!showBackground) {
      return maxWidth != null
          ? ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth!),
              child: content,
            )
          : content;
    }

    // Chip-style badge with background
    final effectiveBackground = backgroundColor ??
        (isSpecial
            ? colorScheme.errorContainer
            : colorScheme.surfaceContainerHighest);

    return Container(
      constraints:
          maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: content,
    );
  }
}

/// An extended lunar info badge that shows full lunar details on tap.
class LunarInfoDetailBadge extends StatelessWidget {
  final DateTime date;

  const LunarInfoDetailBadge({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLunarDetail(context),
      child: LunarInfoBadge(
        date: date,
        showBackground: true,
      ),
    );
  }

  void _showLunarDetail(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lunar = LunarUtils.fromDate(date);

    final dayInChinese = lunar.getDayInChinese();
    final monthInChinese = lunar.getMonthInChinese();
    final yearInGanZhi = lunar.getYearInGanZhi();
    final dayInGanZhi = lunar.getDayInGanZhi();
    final zodiac = lunar.getYearShengXiao();

    final jieQi = lunar.getCurrentJieQi();
    final festivals = lunar.getFestivals();
    final suitable = lunar.getDayYi();
    final avoid = lunar.getDayJi();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lunar date header
            Text(
              '${monthInChinese}月$dayInChinese',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$yearInGanZhi年  $dayInGanZhi日  $zodiac',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            // Solar term
            if (jieQi != null) ...[
              const SizedBox(height: 12),
              Chip(
                label: Text('节气: ${jieQi.getName()}'),
                avatar: const Icon(Icons.wb_sunny, size: 16),
                backgroundColor: colorScheme.tertiaryContainer,
                labelStyle: TextStyle(color: colorScheme.onTertiaryContainer),
              ),
            ],

            // Festivals
            if (festivals.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: festivals
                    .map((f) => Chip(
                          label: Text(f),
                          backgroundColor: colorScheme.errorContainer,
                          labelStyle:
                              TextStyle(color: colorScheme.onErrorContainer),
                        ))
                    .toList(),
              ),
            ],

            // Suitable / Avoid
            if (suitable.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('宜',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: suitable
                          .take(8)
                          .map((s) => Text(s,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
            if (avoid.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('忌',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: avoid
                          .take(8)
                          .map((s) => Text(s,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant)))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
