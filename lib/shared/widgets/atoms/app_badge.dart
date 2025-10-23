import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'app_text.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeVariant variant;
  final AppBadgeSize size;
  final Color? color;
  final Color? backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final IconData? icon;
  final AppBadgeIconPosition iconPosition;
  final bool isDot;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AppBadge(
    this.text, {
    super.key,
    this.variant = AppBadgeVariant.primary,
    this.size = AppBadgeSize.medium,
    this.color,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.icon,
    this.iconPosition = AppBadgeIconPosition.start,
    this.isDot = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeStyle = _getBadgeStyle(theme);

    Widget badge = Container(
      padding: badgeStyle.padding,
      margin: margin,
      decoration: BoxDecoration(
        color: badgeStyle.backgroundColor,
        border: badgeStyle.border,
        borderRadius: badgeStyle.borderRadius,
      ),
      child: _buildBadgeContent(badgeStyle.textColor),
    );

    if (onTap != null || onLongPress != null) {
      badge = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: badgeStyle.borderRadius,
        child: badge,
      );
    }

    return badge;
  }

  Widget _buildBadgeContent(Color textColor) {
    if (isDot) {
      return Container(
        width: _getDotSize(),
        height: _getDotSize(),
        decoration: BoxDecoration(
          color: textColor,
          shape: BoxShape.circle,
        ),
      );
    }

    final textWidget = AppText(
      text,
      variant: _getTextVariant(),
      color: textColor,
    );

    if (icon == null) {
      return textWidget;
    }

    final iconWidget = Icon(
      icon,
      size: _getIconSize(),
      color: textColor,
    );

    if (iconPosition == AppBadgeIconPosition.start) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: AppSpacing.xs),
          textWidget,
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          textWidget,
          const SizedBox(width: AppSpacing.xs),
          iconWidget,
        ],
      );
    }
  }

  _BadgeStyle _getBadgeStyle(ThemeData theme) {
    return _BadgeStyle(
      textColor: color ?? _getDefaultTextColor(theme),
      backgroundColor: backgroundColor ?? _getDefaultBackgroundColor(theme),
      border: border ?? _getDefaultBorder(),
      borderRadius: borderRadius ?? _getDefaultBorderRadius(),
      padding: padding ?? _getDefaultPadding(),
    );
  }

  Color _getDefaultTextColor(ThemeData theme) {
    switch (variant) {
      case AppBadgeVariant.primary:
        return AppColors.onPrimary;
      case AppBadgeVariant.secondary:
        return AppColors.onSecondary;
      case AppBadgeVariant.success:
        return AppColors.onSuccess;
      case AppBadgeVariant.warning:
        return AppColors.onWarning;
      case AppBadgeVariant.error:
        return AppColors.onError;
      case AppBadgeVariant.info:
        return AppColors.onInfo;
      case AppBadgeVariant.outline:
        return AppColors.primary;
      case AppBadgeVariant.ghost:
        return theme.colorScheme.onSurface;
    }
  }

  Color _getDefaultBackgroundColor(ThemeData theme) {
    switch (variant) {
      case AppBadgeVariant.primary:
        return AppColors.primary;
      case AppBadgeVariant.secondary:
        return AppColors.secondary;
      case AppBadgeVariant.success:
        return AppColors.success;
      case AppBadgeVariant.warning:
        return AppColors.warning;
      case AppBadgeVariant.error:
        return AppColors.error;
      case AppBadgeVariant.info:
        return AppColors.info;
      case AppBadgeVariant.outline:
        return AppColors.transparent;
      case AppBadgeVariant.ghost:
        return AppColors.transparent;
    }
  }

  Border? _getDefaultBorder() {
    switch (variant) {
      case AppBadgeVariant.outline:
        return Border.all(color: AppColors.primary);
      case AppBadgeVariant.ghost:
        return null;
      default:
        return null;
    }
  }

  BorderRadius _getDefaultBorderRadius() {
    switch (size) {
      case AppBadgeSize.small:
        return AppSpacing.radiusXsAll;
      case AppBadgeSize.medium:
        return AppSpacing.radiusSmAll;
      case AppBadgeSize.large:
        return AppSpacing.radiusMdAll;
    }
  }

  EdgeInsets _getDefaultPadding() {
    if (isDot) {
      return EdgeInsets.zero;
    }

    switch (size) {
      case AppBadgeSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        );
      case AppBadgeSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppBadgeSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
    }
  }

  double _getDotSize() {
    switch (size) {
      case AppBadgeSize.small:
        return 6.0;
      case AppBadgeSize.medium:
        return 8.0;
      case AppBadgeSize.large:
        return 10.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppBadgeSize.small:
        return AppSpacing.iconXs;
      case AppBadgeSize.medium:
        return AppSpacing.iconSm;
      case AppBadgeSize.large:
        return AppSpacing.iconMd;
    }
  }

  AppTextVariant _getTextVariant() {
    switch (size) {
      case AppBadgeSize.small:
        return AppTextVariant.caption;
      case AppBadgeSize.medium:
        return AppTextVariant.labelSmall;
      case AppBadgeSize.large:
        return AppTextVariant.labelMedium;
    }
  }
}

class _BadgeStyle {
  final Color textColor;
  final Color backgroundColor;
  final Border? border;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const _BadgeStyle({
    required this.textColor,
    required this.backgroundColor,
    this.border,
    required this.borderRadius,
    required this.padding,
  });
}

enum AppBadgeVariant {
  primary,
  secondary,
  success,
  warning,
  error,
  info,
  outline,
  ghost,
}

enum AppBadgeSize {
  small,
  medium,
  large,
}

enum AppBadgeIconPosition {
  start,
  end,
}
