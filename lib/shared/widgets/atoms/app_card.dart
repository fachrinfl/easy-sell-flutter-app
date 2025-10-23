import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final double? elevation;
  final EdgeInsets? padding;

  final EdgeInsets? margin;
  final Color? color;
  final Color? surfaceTintColor;
  final Color? shadowColor;

  final Border? border;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool clickable;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.elevation,
    this.padding,
    this.margin,
    this.color,
    this.surfaceTintColor,
    this.shadowColor,
    this.border,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    this.clickable = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardStyle = _getCardStyle(theme);

    Widget card = Container(
      decoration: BoxDecoration(
        color: cardStyle.color,
        borderRadius: _getBorderRadius(),
        boxShadow: [
          BoxShadow(
            color: cardStyle.shadowColor.withOpacity(0.15),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        width: width,
        height: height,
        padding: cardStyle.padding,
        child: child,
      ),
    );

    if (margin != null) {
      card = Padding(
        padding: margin!,
        child: card,
      );
    }

    if (clickable && (onTap != null || onLongPress != null)) {
      card = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: _getBorderRadius(),
        child: card,
      );
    }

    return card;
  }

  _CardStyle _getCardStyle(ThemeData theme) {
    return _CardStyle(
      elevation: elevation ?? _getDefaultElevation(),
      color: color ?? _getDefaultColor(theme),
      surfaceTintColor: surfaceTintColor ?? _getDefaultSurfaceTintColor(),
      shadowColor: shadowColor ?? _getDefaultShadowColor(),
      shape: _getCardShape(),
      padding: padding ?? _getDefaultPadding(),
    );
  }

  double _getDefaultElevation() {
    switch (variant) {
      case AppCardVariant.elevated:
        return 4.0;
      case AppCardVariant.outlined:
        return 0.0;
      case AppCardVariant.filled:
        return 0.0;
      case AppCardVariant.flat:
        return 0.0;
    }
  }

  Color _getDefaultColor(ThemeData theme) {
    switch (variant) {
      case AppCardVariant.elevated:
        return theme.colorScheme.surface;
      case AppCardVariant.outlined:
        return theme.colorScheme.surface;
      case AppCardVariant.filled:
        return theme.colorScheme.surfaceContainer;
      case AppCardVariant.flat:
        return theme.colorScheme.surface;
    }
  }

  Color _getDefaultSurfaceTintColor() {
    switch (variant) {
      case AppCardVariant.elevated:
        return AppColors.transparent;
      case AppCardVariant.outlined:
        return AppColors.transparent;
      case AppCardVariant.filled:
        return AppColors.transparent;
      case AppCardVariant.flat:
        return AppColors.transparent;
    }
  }

  Color _getDefaultShadowColor() {
    return AppColors.shadowDark;
  }

  BorderRadius _getBorderRadius() {
    return borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg);
  }

  ShapeBorder _getCardShape() {
    if (border != null) {
      return border!;
    }

    final radius = _getBorderRadius();

    switch (variant) {
      case AppCardVariant.elevated:
        return RoundedRectangleBorder(borderRadius: radius);
      case AppCardVariant.outlined:
        return RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: AppColors.outline),
        );
      case AppCardVariant.filled:
        return RoundedRectangleBorder(borderRadius: radius);
      case AppCardVariant.flat:
        return RoundedRectangleBorder(borderRadius: radius);
    }
  }

  EdgeInsets _getDefaultPadding() {
    switch (variant) {
      case AppCardVariant.elevated:
        return AppSpacing.paddingLg;
      case AppCardVariant.outlined:
        return AppSpacing.paddingLg;
      case AppCardVariant.filled:
        return AppSpacing.paddingLg;
      case AppCardVariant.flat:
        return AppSpacing.paddingLg;
    }
  }
}

class _CardStyle {
  final double elevation;
  final Color color;
  final Color surfaceTintColor;
  final Color shadowColor;
  final ShapeBorder shape;
  final EdgeInsets padding;

  const _CardStyle({
    required this.elevation,
    required this.color,
    required this.surfaceTintColor,
    required this.shadowColor,
    required this.shape,
    required this.padding,
  });
}

enum AppCardVariant {
  elevated,
  outlined,
  filled,
  flat,
}
