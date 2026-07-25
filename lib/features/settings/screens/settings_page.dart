import 'package:flutter/material.dart';
import 'package:nari_suraksha/core/theme/app_colors.dart';

/// App settings screen placeholder.
///
/// Groups preferences into logical sections.  Wire real persistence
/// (e.g. SharedPreferences or a SettingsRepository) when implementing
/// the full feature.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ── Local state (placeholder values) ────────────────────────────────────────
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkMode = false;
  bool _biometricLock = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // ── Safety & Permissions ────────────────────────────────────────────
          const _SectionHeader(label: 'Safety & Permissions'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined,
                color: AppColors.primary),
            title: const Text('Push Notifications'),
            subtitle: const Text('Emergency alerts and reminders'),
            value: _notificationsEnabled,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.location_on_outlined,
                color: AppColors.primary),
            title: const Text('Background Location'),
            subtitle: const Text('Share location with emergency contacts'),
            value: _locationEnabled,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _locationEnabled = v),
          ),

          // ── Appearance ───────────────────────────────────────────────────────
          const _SectionHeader(label: 'Appearance'),
          SwitchListTile(
            secondary:
                const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark colour scheme'),
            value: _darkMode,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _darkMode = v),
          ),

          // ── Security ─────────────────────────────────────────────────────────
          const _SectionHeader(label: 'Security'),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint_rounded,
                color: AppColors.primary),
            title: const Text('Biometric Lock'),
            subtitle: const Text('Require fingerprint / face to open app'),
            value: _biometricLock,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _biometricLock = v),
          ),
          ListTile(
            leading:
                const Icon(Icons.key_outlined, color: AppColors.primary),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: navigate to change-password screen
            },
          ),

          // ── About ────────────────────────────────────────────────────────────
          const _SectionHeader(label: 'About'),
          ListTile(
            leading:
                const Icon(Icons.info_outline, color: AppColors.primary),
            title: const Text('App Version'),
            trailing: Text(
              '1.0.0',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined,
                color: AppColors.primary),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: open privacy policy URL / screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined,
                color: AppColors.primary),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: open terms URL / screen
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Private helper ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          fontSize: 14,
        ),
      ),
    );
  }
}
