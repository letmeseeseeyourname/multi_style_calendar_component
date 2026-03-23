import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';

import '../core/models/calendar_event.dart';

/// Form for creating or editing calendar events.
class EventForm extends StatefulWidget {
  /// Pass an existing event to enter edit mode.
  final CalendarEvent? event;

  /// Called when the user saves the form.
  final ValueChanged<CalendarEvent> onSave;

  /// Called when the user cancels.
  final VoidCallback? onCancel;

  /// Initial date hint for new events.
  final DateTime? initialDate;

  const EventForm({
    super.key,
    this.event,
    required this.onSave,
    this.onCancel,
    this.initialDate,
  });

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late bool _isAllDay;
  late Color _selectedColor;

  bool get _isEditing => widget.event != null;

  static const _colorOptions = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFF795548),
    Color(0xFF607D8B),
  ];

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    final now = widget.initialDate ?? DateTime.now();

    _titleController = TextEditingController(text: event?.title ?? '');
    _descriptionController = TextEditingController(
      text: event?.description ?? '',
    );
    _locationController = TextEditingController(text: event?.location ?? '');

    _startDate = event?.startTime ?? now;
    _startTime = event != null
        ? TimeOfDay.fromDateTime(event.startTime)
        : TimeOfDay.fromDateTime(now);
    _endDate = event?.endTime ?? now.add(const Duration(hours: 1));
    _endTime = event != null
        ? TimeOfDay.fromDateTime(event.endTime)
        : TimeOfDay.fromDateTime(now.add(const Duration(hours: 1)));
    _isAllDay = event?.isAllDay ?? false;
    _selectedColor = event?.color ?? _colorOptions[1];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickDate(bool isStart) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final startDateTime = _isAllDay
        ? DateTime(_startDate.year, _startDate.month, _startDate.day)
        : _combineDateAndTime(_startDate, _startTime);
    final endDateTime = _isAllDay
        ? DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59)
        : _combineDateAndTime(_endDate, _endTime);

    if (endDateTime.isBefore(startDateTime)) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.endBeforeStart)));
      return;
    }

    final event = CalendarEvent(
      id: widget.event?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      startTime: startDateTime,
      endTime: endDateTime,
      isAllDay: _isAllDay,
      color: _selectedColor,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
    );

    widget.onSave(event);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l = AppLocalizations.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              _isEditing ? l.editEvent : l.newEvent,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l.title_,
                hintText: l.enterTitle,
                prefixIcon: const Icon(Icons.title),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l.titleRequired;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // All-day toggle
            SwitchListTile(
              title: Text(l.allDayEvent),
              value: _isAllDay,
              onChanged: (value) => setState(() => _isAllDay = value),
              secondary: const Icon(Icons.wb_sunny_outlined),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),

            // Start date/time
            Text(l.start, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(true),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(dateFormat.format(_startDate)),
                  ),
                ),
                if (!_isAllDay) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(true),
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text(_startTime.format(context)),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // End date/time
            Text(l.end, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(false),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(dateFormat.format(_endDate)),
                  ),
                ),
                if (!_isAllDay) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(false),
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text(_endTime.format(context)),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: l.location,
                hintText: l.enterLocation,
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l.description,
                hintText: l.enterDescription,
                prefixIcon: const Icon(Icons.notes),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),

            // Color picker
            Text(l.color, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colorOptions.map((color) {
                final isSelected =
                    _selectedColor.toARGB32() == color.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: colorScheme.outline, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        widget.onCancel ?? () => Navigator.of(context).pop(),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(_isEditing ? l.saveChanges : l.createEvent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
