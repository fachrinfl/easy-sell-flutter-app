import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final AppIconButtonVariant variant;
  final AppIconButtonSize size;
  final bool enabled;
  final bool loading;

  final VoidCallback? onPressed;
  final String? tooltip;
  final ButtonStyle? style;

  const AppIconButton(
    this.icon, {
    super.key,
    this.variant = AppIconButtonVariant.primary,
    this.size = AppIconButtonSize.medium,
    this.enabled = true,
    this.loading = false,
    this.onPressed,
    this.tooltip,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final buttonSize = _getButtonSize();
    final iconSize = _getIconSize();

    Widget child = loading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_getIconColor()),
            ),
          )
        : Icon(
            icon,
            size: iconSize,
            color: _getIconColor(),
          );

    Widget button = IconButton(
      onPressed: enabled && !loading ? onPressed : null,
      style: buttonStyle,
      icon: child,
      tooltip: tooltip,
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: button,
    );
  }

  ButtonStyle _getButtonStyle() {
    final baseStyle = style ?? const ButtonStyle();

    return baseStyle.copyWith(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      minimumSize: WidgetStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _getBackgroundColor().withOpacity(0.3);
        }
        if (states.contains(WidgetState.pressed)) {
          return _getBackgroundColor().withOpacity(0.8);
        }
        if (states.contains(WidgetState.hovered)) {
          return _getBackgroundColor().withOpacity(0.9);
        }
        return _getBackgroundColor();
      }),
      foregroundColor: WidgetStateProperty.all(_getIconColor()),
      overlayColor: WidgetStateProperty.all(_getOverlayColor()),
    );
  }

  double _getButtonSize() {
    switch (size) {
      case AppIconButtonSize.small:
        return AppSpacing.sizeSm;
      case AppIconButtonSize.medium:
        return AppSpacing.sizeMd;
      case AppIconButtonSize.large:
        return AppSpacing.sizeLg;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppIconButtonSize.small:
        return AppSpacing.iconSm;
      case AppIconButtonSize.medium:
        return AppSpacing.iconMd;
      case AppIconButtonSize.large:
        return AppSpacing.iconLg;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case AppIconButtonSize.small:
        return AppSpacing.radiusSm;
      case AppIconButtonSize.medium:
        return AppSpacing.radiusMd;
      case AppIconButtonSize.large:
        return AppSpacing.radiusLg;
    }
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppIconButtonVariant.primary:
        return AppColors.primary;
      case AppIconButtonVariant.secondary:
        return AppColors.surfaceContainer;
      case AppIconButtonVariant.outline:
        return AppColors.transparent;
      case AppIconButtonVariant.ghost:
        return AppColors.transparent;
      case AppIconButtonVariant.danger:
        return AppColors.error;
    }
  }

  Color _getIconColor() {
    switch (variant) {
      case AppIconButtonVariant.primary:
        return AppColors.onPrimary;
      case AppIconButtonVariant.secondary:
        return AppColors.onSurface;
      case AppIconButtonVariant.outline:
        return AppColors.primary;
      case AppIconButtonVariant.ghost:
        return AppColors.onSurfaceVariant;
      case AppIconButtonVariant.danger:
        return AppColors.onError;
    }
  }

  Color _getOverlayColor() {
    switch (variant) {
      case AppIconButtonVariant.primary:
        return AppColors.onPrimary.withOpacity(0.1);
      case AppIconButtonVariant.secondary:
        return AppColors.onSurface.withOpacity(0.1);
      case AppIconButtonVariant.outline:
        return AppColors.primary.withOpacity(0.1);
      case AppIconButtonVariant.ghost:
        return AppColors.onSurfaceVariant.withOpacity(0.1);
      case AppIconButtonVariant.danger:
        return AppColors.onError.withOpacity(0.1);
    }
  }
}

enum AppIconButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

enum AppIconButtonSize {
  small,
  medium,
  large,
}
