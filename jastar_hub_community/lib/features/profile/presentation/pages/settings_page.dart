import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/features/auth/presentation/bloc/auth_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Section: General
          _buildSectionHeader('General', isDark),
          _buildSettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'Auto-detecting from system',
            onTap: () {},
            isDark: isDark,
          ),
          _buildSettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Theme',
            subtitle: 'System Default',
            onTap: () {},
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Section: Notifications
          _buildSectionHeader('Notifications', isDark),
          _buildSettingsTile(
            icon: Icons.notifications_rounded,
            title: 'Push Notifications',
            trailing: Switch(
              value: true,
              onChanged: (v) {},
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              activeThumbColor: AppColors.primary,
            ),
            isDark: isDark,
          ),
          _buildSettingsTile(
            icon: Icons.email_rounded,
            title: 'Email Digest',
            trailing: Switch(
              value: false,
              onChanged: (v) {},
              activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              activeThumbColor: AppColors.primary,
            ),
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Section: Account
          _buildSectionHeader('Account', isDark),
          _buildSettingsTile(
            icon: Icons.person_rounded,
            title: 'Edit Profile',
            onTap: () {},
            isDark: isDark,
          ),
          _buildSettingsTile(
            icon: Icons.security_rounded,
            title: 'Security',
            onTap: () {},
            isDark: isDark,
          ),

          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                foregroundColor: AppColors.error,
                elevation: 0,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
                context.go('/login');
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDarkElevated : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            )
          : null,
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
      onTap: onTap,
    );
  }
}
