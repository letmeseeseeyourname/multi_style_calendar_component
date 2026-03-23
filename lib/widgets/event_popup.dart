import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

import '../core/models/calendar_event.dart';

/// Bottom sheet showing event details.
class EventPopup extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EventPopup({
    super.key,
    required this.event,
    this.onEdit,
    this.onDelete,
  });

  /// Shows this popup as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required CalendarEvent event,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          EventPopup(event: event, onEdit: onEdit, onDelete: onDelete),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l = AppLocalizations.of(context);
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color indicator and title
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  event.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Time
          _DetailRow(
            icon: Icons.access_time,
            child: Text(
              event.isAllDay
                  ? '${l.allDay}  ${dateFormat.format(event.startTime)}'
                  : event.isMultiDay
                  ? '${dateFormat.format(event.startTime)} ${timeFormat.format(event.startTime)}'
                        ' - ${dateFormat.format(event.endTime)} ${timeFormat.format(event.endTime)}'
                  : '${dateFormat.format(event.startTime)}  '
                        '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // Location
          if (event.location != null && event.location!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.location_on_outlined,
              child: Text(
                event.location!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],

          // Description
          if (event.description != null && event.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.notes,
              child: Text(
                event.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],

          // Attendees
          if (event.attendees != null && event.attendees!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.people_outline,
              child: Text(
                event.attendees!.join(', '),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],

          // Action buttons
          if (onEdit != null || onDelete != null) ...[
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onDelete != null)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete!();
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: Text(l.delete_),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                    ),
                  ),
                if (onEdit != null) ...[
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onEdit!();
                    },
                    child: Text(l.edit),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const _DetailRow({required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}
