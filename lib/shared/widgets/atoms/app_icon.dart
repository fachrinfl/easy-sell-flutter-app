import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final AppIconSize size;

  final Color? color;
  final Color? backgroundColor;

  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool clickable;
  final AppIconVariant variant;
  final String? tooltip;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.clickable = false,
    this.variant = AppIconVariant.default_,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconStyle = _getIconStyle(theme);

    Widget iconWidget = Icon(
      icon,
      size: iconStyle.size,
      color: iconStyle.color,
    );

    if (variant != AppIconVariant.default_) {
      iconWidget = Container(
        width: iconStyle.containerSize,
        height: iconStyle.containerSize,
        padding: iconStyle.padding,
        margin: margin,
        decoration: BoxDecoration(
          color: iconStyle.backgroundColor,
          border: iconStyle.border,
          borderRadius: iconStyle.borderRadius,
        ),
        child: iconWidget,
      );
    } else if (margin != null) {
      iconWidget = Padding(
        padding: margin!,
        child: iconWidget,
      );
    }

    if (clickable && (onTap != null || onLongPress != null)) {
      iconWidget = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: iconStyle.borderRadius,
        child: iconWidget,
      );
    }

    if (tooltip != null) {
      iconWidget = Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  _IconStyle _getIconStyle(ThemeData theme) {
    return _IconStyle(
      size: _getIconSize(),
      color: color ?? _getDefaultColor(theme),
      backgroundColor: backgroundColor ?? _getDefaultBackgroundColor(theme),
      border: border ?? _getDefaultBorder(),
      borderRadius: borderRadius ?? _getDefaultBorderRadius(),
      padding: padding ?? _getDefaultPadding(),
      containerSize: _getContainerSize(),
    );
  }

  double _getIconSize() {
    switch (size) {
      case AppIconSize.xsmall:
        return AppSpacing.iconXs;
      case AppIconSize.small:
        return AppSpacing.iconSm;
      case AppIconSize.medium:
        return AppSpacing.iconMd;
      case AppIconSize.large:
        return AppSpacing.iconLg;
      case AppIconSize.xlarge:
        return AppSpacing.iconXl;
      case AppIconSize.xxlarge:
        return AppSpacing.iconXl2;
    }
  }

  double _getContainerSize() {
    switch (size) {
      case AppIconSize.xsmall:
        return AppSpacing.sizeXs;
      case AppIconSize.small:
        return AppSpacing.sizeSm;
      case AppIconSize.medium:
        return AppSpacing.sizeMd;
      case AppIconSize.large:
        return AppSpacing.sizeLg;
      case AppIconSize.xlarge:
        return AppSpacing.sizeXl;
      case AppIconSize.xxlarge:
        return AppSpacing.sizeXl2;
    }
  }

  Color _getDefaultColor(ThemeData theme) {
    switch (variant) {
      case AppIconVariant.default_:
        return theme.colorScheme.onSurface;
      case AppIconVariant.primary:
        return AppColors.primary;
      case AppIconVariant.secondary:
        return AppColors.secondary;
      case AppIconVariant.success:
        return AppColors.success;
      case AppIconVariant.warning:
        return AppColors.warning;
      case AppIconVariant.error:
        return AppColors.error;
      case AppIconVariant.info:
        return AppColors.info;
      case AppIconVariant.muted:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getDefaultBackgroundColor(ThemeData theme) {
    switch (variant) {
      case AppIconVariant.default_:
        return AppColors.transparent;
      case AppIconVariant.primary:
        return AppColors.primaryContainer;
      case AppIconVariant.secondary:
        return AppColors.secondaryContainer;
      case AppIconVariant.success:
        return AppColors.successContainer;
      case AppIconVariant.warning:
        return AppColors.warningContainer;
      case AppIconVariant.error:
        return AppColors.errorContainer;
      case AppIconVariant.info:
        return AppColors.infoContainer;
      case AppIconVariant.muted:
        return theme.colorScheme.surfaceContainer;
    }
  }

  Border? _getDefaultBorder() {
    switch (variant) {
      case AppIconVariant.default_:
        return null;
      case AppIconVariant.primary:
        return null;
      case AppIconVariant.secondary:
        return null;
      case AppIconVariant.success:
        return null;
      case AppIconVariant.warning:
        return null;
      case AppIconVariant.error:
        return null;
      case AppIconVariant.info:
        return null;
      case AppIconVariant.muted:
        return null;
    }
  }

  BorderRadius _getDefaultBorderRadius() {
    switch (variant) {
      case AppIconVariant.default_:
        return BorderRadius.zero;
      case AppIconVariant.primary:
        return BorderRadius.circular(AppSpacing.radiusSm);
      case AppIconVariant.secondary:
        return BorderRadius.circular(AppSpacing.radiusSm);
      case AppIconVariant.success:
        return BorderRadius.circular(AppSpacing.radiusSm);
      case AppIconVariant.warning:
        return BorderRadius.circular(AppSpacing.radiusSm);
      case AppIconVariant.error:
        return BorderRadius.circular(AppSpacing.radiusSm);
      case AppIconVariant.info:
        return BorderRadius.circular(AppSpacing.radiusSm);
      case AppIconVariant.muted:
        return BorderRadius.circular(AppSpacing.radiusSm);
    }
  }

  EdgeInsets _getDefaultPadding() {
    switch (variant) {
      case AppIconVariant.default_:
        return EdgeInsets.zero;
      case AppIconVariant.primary:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppIconVariant.secondary:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppIconVariant.success:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppIconVariant.warning:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppIconVariant.error:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppIconVariant.info:
        return const EdgeInsets.all(AppSpacing.sm);
      case AppIconVariant.muted:
        return const EdgeInsets.all(AppSpacing.sm);
    }
  }
}

class _IconStyle {
  final double size;
  final Color color;
  final Color backgroundColor;
  final Border? border;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final double containerSize;

  const _IconStyle({
    required this.size,
    required this.color,
    required this.backgroundColor,
    this.border,
    required this.borderRadius,
    required this.padding,
    required this.containerSize,
  });
}

enum AppIconSize {
  xsmall,
  small,
  medium,
  large,
  xlarge,
  xxlarge,
}

enum AppIconVariant {
  default_,
  primary,
  secondary,
  success,
  warning,
  error,
  info,
  muted,
}
