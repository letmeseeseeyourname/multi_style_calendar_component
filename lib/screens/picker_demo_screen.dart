import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../pickers/single_picker.dart';
import '../pickers/multi_picker.dart';
import '../pickers/range_picker.dart';
import '../pickers/month_picker.dart';
import '../pickers/year_picker.dart' as custom_year_picker;
import '../pickers/datetime_picker.dart';

/// 选择器演示
class PickerDemoScreen extends StatefulWidget {
  const PickerDemoScreen({super.key});

  @override
  State<PickerDemoScreen> createState() => _PickerDemoScreenState();
}

class _PickerDemoScreenState extends State<PickerDemoScreen> {
  String? _result;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.datePickers)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _result != null ? l.resultLabel(_result!) : l.tapToShowPicker,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPickerButton(
            icon: Icons.calendar_today,
            label: l.singleDate,
            color: Colors.blue,
            onTap: () async {
              final date = await SingleDatePicker.show(context);
              if (date != null) {
                setState(() => _result = '${date.year}-${date.month}-${date.day}');
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.date_range,
            label: l.multiDate,
            color: Colors.green,
            onTap: () async {
              final dates = await MultiDatePicker.show(context);
              if (dates != null && dates.isNotEmpty) {
                setState(() => _result = l.nSelected(dates.length));
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.swap_horiz,
            label: l.rangeSelect,
            color: Colors.orange,
            onTap: () async {
              final range = await DateRangePicker.show(context);
              if (range != null) {
                setState(() => _result =
                    '${range.start.month}/${range.start.day} - ${range.end.month}/${range.end.day}');
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.calendar_view_month,
            label: l.monthSelect,
            color: Colors.purple,
            onTap: () async {
              final date = await MonthPicker.show(context);
              if (date != null) {
                setState(() => _result = l.yearMonth(date.year, date.month));
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.calendar_view_day,
            label: l.yearSelect,
            color: Colors.teal,
            onTap: () async {
              final year = await custom_year_picker.YearPicker.show(context);
              if (year != null) {
                setState(() => _result = '$year${l.yearSuffix}');
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.access_time,
            label: l.dateTimeSelect,
            color: Colors.red,
            onTap: () async {
              final dt = await DateTimePicker.show(context);
              if (dt != null) {
                setState(() => _result =
                    '${dt.year}-${dt.month}-${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPickerButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
