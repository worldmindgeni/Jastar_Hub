import 'package:flutter/material.dart';
import 'package:jastar_hub_community/core/theme/app_colors.dart';
import 'package:jastar_hub_community/core/constants/app_constants.dart';

enum AppButtonVariant { gradient, filled, outlined, text }

/// Premium button widget with gradient, filled, outlined, and text variants.
/// Features micro-animations on press.
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final LinearGradient? gradient;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.gradient,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height,
    this.fontSize,
    this.padding,
    this.gradient,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final height = widget.height ?? 56.0;
    final fontSize = widget.fontSize ?? 16.0;
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => _animController.forward(),
        onTapUp: isDisabled
            ? null
            : (_) {
                _animController.reverse();
                widget.onPressed?.call();
              },
        onTapCancel: isDisabled ? null : () => _animController.reverse(),
        child: AnimatedOpacity(
          duration: AppConstants.fastAnimation,
          opacity: isDisabled ? 0.6 : 1.0,
          child: _buildButton(theme, isDark, height, fontSize),
        ),
      ),
    );
  }

  Widget _buildButton(
      ThemeData theme, bool isDark, double height, double fontSize) {
    switch (widget.variant) {
      case AppButtonVariant.gradient:
        return _buildGradientButton(theme, height, fontSize);
      case AppButtonVariant.filled:
        return _buildFilledButton(theme, isDark, height, fontSize);
      case AppButtonVariant.outlined:
        return _buildOutlinedButton(theme, isDark, height, fontSize);
      case AppButtonVariant.text:
        return _buildTextButton(theme, fontSize);
    }
  }

  Widget _buildGradientButton(
      ThemeData theme, double height, double fontSize) {
    return Container(
      width: widget.isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        gradient: widget.gradient ?? AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(child: _buildContent(Colors.white, fontSize)),
      ),
    );
  }

  Widget _buildFilledButton(
      ThemeData theme, bool isDark, double height, double fontSize) {
    return Container(
      width: widget.isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
      ),
      child: Center(child: _buildContent(Colors.white, fontSize)),
    );
  }

  Widget _buildOutlinedButton(
      ThemeData theme, bool isDark, double height, double fontSize) {
    return Container(
      width: widget.isFullWidth ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
      ),
      child: Center(
        child: _buildContent(
          isDark ? AppColors.textPrimaryDark : AppColors.primary,
          fontSize,
        ),
      ),
    );
  }

  Widget _buildTextButton(ThemeData theme, double fontSize) {
    return Padding(
      padding:
          widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _buildContent(AppColors.primary, fontSize),
    );
  }

  Widget _buildContent(Color color, double fontSize) {
    if (widget.isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}
