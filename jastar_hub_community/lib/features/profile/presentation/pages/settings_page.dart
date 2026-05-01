import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jastar_hub_community/app/cubit/app_cubit.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          appBar: AppBar(
            title: Text(context.tr('settings')),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // Section: General
              _buildSectionHeader(context.tr('categories'), isDark), // Using categories as generic label or better just 'General'
              _buildSettingsTile(
                icon: Icons.language_rounded,
                title: context.tr('choose_language'),
                subtitle: _getLanguageName(state.locale.languageCode, context),
                onTap: () => _showLanguageDialog(context),
                isDark: isDark,
              ),
              _buildSettingsTile(
                icon: Icons.dark_mode_rounded,
                title: context.tr('theme'),
                subtitle: _getThemeName(state.themeMode, context),
                onTap: () => _showThemeDialog(context),
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // Section: Notifications
              _buildSectionHeader(context.tr('notifications'), isDark),
              _buildSettingsTile(
                icon: Icons.notifications_rounded,
                title: 'Push Notifications',
                trailing: Switch(
                  value: state.pushNotificationsEnabled,
                  onChanged: (v) => context.read<AppCubit>().setPushEnabled(v),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.primary,
                ),
                isDark: isDark,
              ),
              _buildSettingsTile(
                icon: Icons.email_rounded,
                title: 'Email Digest',
                trailing: Switch(
                  value: false, // Not implemented in cubit yet
                  onChanged: (v) {},
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.primary,
                ),
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // Section: Account
              _buildSectionHeader(context.tr('profile'), isDark),
              _buildSettingsTile(
                icon: Icons.person_rounded,
                title: context.tr('edit_profile'),
                onTap: () => context.push('/edit-profile'),
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
                  child: Text(
                    context.tr('logout'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getThemeName(ThemeMode mode, BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return context.tr('theme_light');
      case ThemeMode.dark:
        return context.tr('theme_dark');
      case ThemeMode.system:
        return context.tr('theme_system');
    }
  }

  String _getLanguageName(String code, BuildContext context) {
    switch (code) {
      case 'en':
        return context.tr('english');
      case 'ru':
        return context.tr('russian');
      case 'kk':
        return context.tr('kazakh');
      default:
        return code;
    }
  }

  void _showThemeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.tr('theme_light')),
                onTap: () {
                  context.read<AppCubit>().setTheme(ThemeMode.light);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(context.tr('theme_dark')),
                onTap: () {
                  context.read<AppCubit>().setTheme(ThemeMode.dark);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(context.tr('theme_system')),
                onTap: () {
                  context.read<AppCubit>().setTheme(ThemeMode.system);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(context.tr('russian')),
                onTap: () {
                  context.read<AppCubit>().setLocale('ru');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(context.tr('english')),
                onTap: () {
                  context.read<AppCubit>().setLocale('en');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(context.tr('kazakh')),
                onTap: () {
                  context.read<AppCubit>().setLocale('kk');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
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
