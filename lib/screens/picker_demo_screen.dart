import 'package:flutter/material.dart';
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
  String _result = '点击按钮查看选择器';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('日期选择器')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '选择结果: $_result',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPickerButton(
            icon: Icons.calendar_today,
            label: '单选日期',
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
            label: '多选日期',
            color: Colors.green,
            onTap: () async {
              final dates = await MultiDatePicker.show(context);
              if (dates != null && dates.isNotEmpty) {
                setState(() => _result = '已选 ${dates.length} 个日期');
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.swap_horiz,
            label: '范围选择',
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
            label: '月份选择',
            color: Colors.purple,
            onTap: () async {
              final date = await MonthPicker.show(context);
              if (date != null) {
                setState(() => _result = '${date.year}年${date.month}月');
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.calendar_view_day,
            label: '年份选择',
            color: Colors.teal,
            onTap: () async {
              final year = await custom_year_picker.YearPicker.show(context);
              if (year != null) {
                setState(() => _result = '${year}年');
              }
            },
          ),
          _buildPickerButton(
            icon: Icons.access_time,
            label: '日期时间选择',
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
