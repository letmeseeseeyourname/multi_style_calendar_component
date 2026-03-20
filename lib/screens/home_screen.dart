import 'package:flutter/material.dart';
import 'view_demo_screen.dart';
import 'style_demo_screen.dart';
import 'picker_demo_screen.dart';
import 'business_demo_screen.dart';
import 'playground_screen.dart';

/// 首页导航
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('多样式日历组件库'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(theme),
          const SizedBox(height: 24),
          _buildSection(
            context,
            icon: Icons.calendar_view_month,
            title: '视图模式',
            subtitle: '年 / 月 / 周 / 日 / 日程 / 时间线',
            color: Colors.blue,
            onTap: () => _navigate(context, const ViewDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.palette,
            title: '视觉风格',
            subtitle: '经典 / 卡片 / 圆形 / 热力图 / 翻页 / 极简 / 毛玻璃',
            color: Colors.purple,
            onTap: () => _navigate(context, const StyleDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.touch_app,
            title: '日期选择器',
            subtitle: '单选 / 多选 / 范围 / 月份 / 年份 / 日期时间',
            color: Colors.teal,
            onTap: () => _navigate(context, const PickerDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.business_center,
            title: '业务场景',
            subtitle: '考勤 / 习惯 / 预约 / 价格 / 农历 / 倒计时 / 共享',
            color: Colors.orange,
            onTap: () => _navigate(context, const BusinessDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.tune,
            title: '自由配置',
            subtitle: '自定义日历参数与交互',
            color: Colors.green,
            onTap: () => _navigate(context, const PlaygroundScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.calendar_month,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Flutter 多样式日历',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '涵盖多种历法、视图、交互与业务场景',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
