import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'app_text.dart';

class AppTextButton extends StatelessWidget {
  final String text;

  final AppTextButtonVariant variant;

  final AppTextButtonSize size;

  final bool enabled;

  final bool loading;

  final IconData? icon;

  final AppTextButtonIconPosition iconPosition;

  final VoidCallback? onPressed;

  final double? width;

  final double? height;

  final ButtonStyle? style;

  const AppTextButton(
    this.text, {
    super.key,
    this.variant = AppTextButtonVariant.primary,
    this.size = AppTextButtonSize.medium,
    this.enabled = true,
    this.loading = false,
    this.icon,
    this.iconPosition = AppTextButtonIconPosition.start,
    this.onPressed,
    this.width,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final buttonHeight = _getButtonHeight();
    final buttonPadding = _getButtonPadding();

    Widget child = _buildButtonContent();

    if (width != null || height != null) {
      child = SizedBox(
        width: width,
        height: height ?? buttonHeight,
        child: child,
      );
    }

    return TextButton(
      onPressed: enabled && !loading ? onPressed : null,
      style: buttonStyle,
      child: child,
    );
  }

  Widget _buildButtonContent() {
    if (loading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    if (icon != null) {
      final iconWidget = Icon(
        icon,
        size: _getIconSize(),
        color: _getTextColor(),
      );

      if (iconPosition == AppTextButtonIconPosition.start) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            SizedBox(width: AppSpacing.sm),
            AppText(text, variant: _getTextVariant(), color: _getTextColor()),
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(text, variant: _getTextVariant(), color: _getTextColor()),
            SizedBox(width: AppSpacing.sm),
            iconWidget,
          ],
        );
      }
    }

    return AppText(text, variant: _getTextVariant(), color: _getTextColor());
  }

  ButtonStyle _getButtonStyle() {
    final baseStyle = style ?? const ButtonStyle();

    return baseStyle.copyWith(
      padding: WidgetStateProperty.all(_getButtonPadding()),
      minimumSize: WidgetStateProperty.all(
        Size(width ?? 0, height ?? _getButtonHeight()),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _getTextColor().withOpacity(0.3);
        }
        if (states.contains(WidgetState.pressed)) {
          return _getTextColor().withOpacity(0.8);
        }
        if (states.contains(WidgetState.hovered)) {
          return _getTextColor().withOpacity(0.9);
        }
        return _getTextColor();
      }),
      overlayColor: WidgetStateProperty.all(_getOverlayColor()),
    );
  }

  EdgeInsets _getButtonPadding() {
    switch (size) {
      case AppTextButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        );
      case AppTextButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        );
      case AppTextButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl2,
          vertical: AppSpacing.md,
        );
    }
  }

  double _getButtonHeight() {
    switch (size) {
      case AppTextButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case AppTextButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case AppTextButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppTextButtonSize.small:
        return AppSpacing.iconSm;
      case AppTextButtonSize.medium:
        return AppSpacing.iconMd;
      case AppTextButtonSize.large:
        return AppSpacing.iconLg;
    }
  }

  AppTextVariant _getTextVariant() {
    switch (size) {
      case AppTextButtonSize.small:
        return AppTextVariant.buttonSmall;
      case AppTextButtonSize.medium:
        return AppTextVariant.buttonMedium;
      case AppTextButtonSize.large:
        return AppTextVariant.buttonLarge;
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case AppTextButtonVariant.primary:
        return AppColors.primary;
      case AppTextButtonVariant.secondary:
        return AppColors.secondary;
      case AppTextButtonVariant.danger:
        return AppColors.error;
      case AppTextButtonVariant.ghost:
        return AppColors.onSurfaceVariant;
    }
  }

  Color _getOverlayColor() {
    switch (variant) {
      case AppTextButtonVariant.primary:
        return AppColors.primary.withOpacity(0.1);
      case AppTextButtonVariant.secondary:
        return AppColors.secondary.withOpacity(0.1);
      case AppTextButtonVariant.danger:
        return AppColors.error.withOpacity(0.1);
      case AppTextButtonVariant.ghost:
        return AppColors.onSurfaceVariant.withOpacity(0.1);
    }
  }
}

enum AppTextButtonVariant { primary, secondary, danger, ghost }

enum AppTextButtonSize { small, medium, large }

enum AppTextButtonIconPosition { start, end }
