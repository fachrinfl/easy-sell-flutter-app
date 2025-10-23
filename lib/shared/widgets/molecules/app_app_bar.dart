import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_icon_button.dart';
import '../atoms/app_text.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;

  final Widget? leading;

  final List<Widget>? actions;

  final Color? backgroundColor;

  final Color? foregroundColor;

  final double? elevation;

  final bool? centerTitle;

  final bool automaticallyImplyLeading;

  final PreferredSizeWidget? bottom;

  final Widget? flexibleSpace;

  final VoidCallback? onBackPressed;

  final AppAppBarVariant variant;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.flexibleSpace,
    this.onBackPressed,
    this.variant = AppAppBarVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarStyle = _getAppBarStyle(theme);

    return AppBar(
      title: titleWidget ?? (title != null ? _buildTitle(appBarStyle) : null),
      leading: _buildLeading(context, appBarStyle),
      actions: _buildActions(context, appBarStyle),
      backgroundColor: appBarStyle.backgroundColor,
      foregroundColor: appBarStyle.foregroundColor,
      elevation: appBarStyle.elevation,
      centerTitle: centerTitle ?? _getDefaultCenterTitle(),
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
      surfaceTintColor: AppColors.transparent,
    );
  }

  Widget _buildTitle(_AppBarStyle style) {
    return AppText(
      title!,
      variant: AppTextVariant.titleLarge,
      color: style.foregroundColor,
    );
  }

  Widget? _buildLeading(BuildContext context, _AppBarStyle style) {
    if (leading != null) {
      return leading;
    }

    if (automaticallyImplyLeading && Navigator.canPop(context)) {
      return AppIconButton(
        Icons.arrow_back,
        variant: AppIconButtonVariant.ghost,
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context, _AppBarStyle style) {
    if (actions == null || actions!.isEmpty) {
      return null;
    }

    return actions!.map((action) {
      return Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xs),
        child: action,
      );
    }).toList();
  }

  bool _getDefaultCenterTitle() {
    switch (variant) {
      case AppAppBarVariant.standard:
        return true;
      case AppAppBarVariant.large:
        return true;
      case AppAppBarVariant.minimal:
        return false;
    }
  }

  _AppBarStyle _getAppBarStyle(ThemeData theme) {
    return _AppBarStyle(
      backgroundColor: backgroundColor ?? _getDefaultBackgroundColor(theme),
      foregroundColor: foregroundColor ?? _getDefaultForegroundColor(theme),
      elevation: elevation ?? _getDefaultElevation(),
    );
  }

  Color _getDefaultBackgroundColor(ThemeData theme) {
    switch (variant) {
      case AppAppBarVariant.standard:
        return theme.colorScheme.surface;
      case AppAppBarVariant.large:
        return theme.colorScheme.surface;
      case AppAppBarVariant.minimal:
        return AppColors.transparent;
    }
  }

  Color _getDefaultForegroundColor(ThemeData theme) {
    return theme.colorScheme.onSurface;
  }

  double _getDefaultElevation() {
    switch (variant) {
      case AppAppBarVariant.standard:
        return 0.0;
      case AppAppBarVariant.large:
        return 0.0;
      case AppAppBarVariant.minimal:
        return 0.0;
    }
  }

  @override
  Size get preferredSize {
    switch (variant) {
      case AppAppBarVariant.standard:
        return const Size.fromHeight(AppSpacing.appBarHeight);
      case AppAppBarVariant.large:
        return const Size.fromHeight(AppSpacing.appBarHeight * 1.5);
      case AppAppBarVariant.minimal:
        return const Size.fromHeight(AppSpacing.appBarHeight * 0.8);
    }
  }
}

class _AppBarStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;

  const _AppBarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
  });
}

enum AppAppBarVariant { standard, large, minimal }
