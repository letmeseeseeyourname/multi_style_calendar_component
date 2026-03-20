import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import 'view_demo_screen.dart';
import 'style_demo_screen.dart';
import 'picker_demo_screen.dart';
import 'business_demo_screen.dart';
import 'playground_screen.dart';

/// 首页导航
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          TextButton.icon(
            onPressed: () {
              final newLocale = locale.languageCode == 'zh'
                  ? const Locale('en', 'US')
                  : const Locale('zh', 'CN');
              ref.read(localeProvider.notifier).state = newLocale;
            },
            icon: const Icon(Icons.language),
            label: Text(locale.languageCode == 'zh' ? 'EN' : '中文'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context, theme),
          const SizedBox(height: 24),
          _buildSection(
            context,
            icon: Icons.calendar_view_month,
            title: l.viewModes,
            subtitle: l.viewModesSubtitle,
            color: Colors.blue,
            onTap: () => _navigate(context, const ViewDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.palette,
            title: l.visualStyles,
            subtitle: l.visualStylesSubtitle,
            color: Colors.purple,
            onTap: () => _navigate(context, const StyleDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.touch_app,
            title: l.datePickers,
            subtitle: l.datePickersSubtitle,
            color: Colors.teal,
            onTap: () => _navigate(context, const PickerDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.business_center,
            title: l.businessScenarios,
            subtitle: l.businessScenariosSubtitle,
            color: Colors.orange,
            onTap: () => _navigate(context, const BusinessDemoScreen()),
          ),
          _buildSection(
            context,
            icon: Icons.tune,
            title: l.playground,
            subtitle: l.playgroundSubtitle,
            color: Colors.green,
            onTap: () => _navigate(context, const PlaygroundScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final l = AppLocalizations.of(context);
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
              l.appHeaderTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.appHeaderSubtitle,
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
