import 'package:flutter/material.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';

/// Main scaffold with animated bottom navigation bar.
class ShellPage extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final void Function(int) onTabChanged;

  const ShellPage({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: context.tr('nav_home'),
                  isDark: isDark,
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.event_outlined,
                  activeIcon: Icons.event_rounded,
                  label: context.tr('nav_events'),
                  isDark: isDark,
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map_rounded,
                  label: context.tr('nav_map'),
                  isDark: isDark,
                ),
                _buildNavItem(
                  context,
                  index: 3,
                  icon: Icons.chat_bubble_outline_rounded,
                  activeIcon: Icons.chat_bubble_rounded,
                  label: context.tr('nav_chat'),
                  isDark: isDark,
                ),
                _buildNavItem(
                  context,
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: context.tr('nav_profile'),
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDark,
  }) {
    final isActive = widget.currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.onTabChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark
                  ? AppColors.primaryLight.withValues(alpha: 0.12)
                  : AppColors.primary.withValues(alpha: 0.08))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                size: 24,
                color: isActive
                    ? (isDark ? AppColors.primaryLight : AppColors.primary)
                    : (isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? (isDark ? AppColors.primaryLight : AppColors.primary)
                    : (isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
