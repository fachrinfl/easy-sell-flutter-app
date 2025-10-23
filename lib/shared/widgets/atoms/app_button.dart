import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool enabled;
  final bool loading;

  final IconData? icon;
  final AppButtonIconPosition iconPosition;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final ButtonStyle? style;

  const AppButton(
    this.text, {
    super.key,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.enabled = true,
    this.loading = false,
    this.icon,
    this.iconPosition = AppButtonIconPosition.start,
    this.onPressed,
    this.width,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getButtonStyle(theme);
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

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: enabled && !loading ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: enabled && !loading ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: enabled && !loading ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
      case AppButtonVariant.danger:
        return ElevatedButton(
          onPressed: enabled && !loading ? onPressed : null,
          style: buttonStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(
              enabled ? AppColors.error : AppColors.error.withOpacity(0.3),
            ),
            foregroundColor: WidgetStateProperty.all(AppColors.onError),
          ),
          child: child,
        );
    }
  }

  Widget _buildButtonContent() {
    if (loading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary ? AppColors.onPrimary : AppColors.primary,
              ),
            ),
          ),
        ],
      );
    }

    if (icon != null) {
      final iconWidget = Icon(
        icon,
        size: _getIconSize(),
      );

      if (iconPosition == AppButtonIconPosition.start) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: AppText(
                text,
                variant: _getTextVariant(),
                color: _getTextColor(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AppText(
                text,
                variant: _getTextVariant(),
                color: _getTextColor(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            iconWidget,
          ],
        );
      }
    }

    return Center(
      child: AppText(
        text,
        variant: _getTextVariant(),
        color: _getTextColor(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
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
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.gray300;
        }
        switch (variant) {
          case AppButtonVariant.primary:
            return AppColors.primary;
          case AppButtonVariant.secondary:
            return AppColors.transparent;
          case AppButtonVariant.text:
            return AppColors.transparent;
          case AppButtonVariant.danger:
            return AppColors.error;
        }
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.gray500;
        }
        switch (variant) {
          case AppButtonVariant.primary:
            return AppColors.onPrimary;
          case AppButtonVariant.secondary:
            return AppColors.primary;
          case AppButtonVariant.text:
            return AppColors.primary;
          case AppButtonVariant.danger:
            return AppColors.onError;
        }
      }),
    );
  }

  EdgeInsets _getButtonPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl2,
          vertical: AppSpacing.md,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl3,
          vertical: AppSpacing.lg,
        );
    }
  }

  double _getButtonHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case AppButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case AppButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.iconSm;
      case AppButtonSize.medium:
        return AppSpacing.iconMd;
      case AppButtonSize.large:
        return AppSpacing.iconLg;
    }
  }

  AppTextVariant _getTextVariant() {
    switch (size) {
      case AppButtonSize.small:
        return AppTextVariant.buttonSmall;
      case AppButtonSize.medium:
        return AppTextVariant.buttonMedium;
      case AppButtonSize.large:
        return AppTextVariant.buttonLarge;
    }
  }

  Color? _getTextColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.onPrimary;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.text:
        return AppColors.primary;
      case AppButtonVariant.danger:
        return AppColors.onError;
    }
  }
}

enum AppButtonVariant {
  primary,
  secondary,
  text,
  danger,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

enum AppButtonIconPosition {
  start,
  end,
}
