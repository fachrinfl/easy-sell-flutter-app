import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AppSearchField extends StatefulWidget {
  final String? hint;

  final String? initialValue;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool enabled;

  final bool autofocus;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onClear;

  final ValueChanged<bool>? onFocusChanged;

  final String? Function(String?)? validator;

  final AppSearchFieldVariant variant;

  final AppSearchFieldSize size;

  final bool showClearButton;

  final bool showSearchButton;

  final IconData? searchIcon;

  final IconData? clearIcon;

  const AppSearchField({
    super.key,
    this.hint,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFocusChanged,
    this.validator,
    this.variant = AppSearchFieldVariant.outlined,
    this.size = AppSearchFieldSize.medium,
    this.showClearButton = true,
    this.showSearchButton = true,
    this.searchIcon,
    this.clearIcon,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;

    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);

    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
    widget.onFocusChanged?.call(_hasFocus);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = _buildInputDecoration(theme);

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      style: _getTextStyle(theme),
      decoration: decoration,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme) {
    return InputDecoration(
      hintText: widget.hint ?? 'Search...',
      prefixIcon: widget.showSearchButton
          ? Icon(
              widget.searchIcon ?? Icons.search,
              size: _getIconSize(),
              color: _getIconColor(theme),
            )
          : null,
      suffixIcon: _buildSuffixIcon(theme),
      contentPadding: _getContentPadding(),
      filled: widget.variant == AppSearchFieldVariant.filled,
      border: _getBorder(),
      enabledBorder: _getEnabledBorder(),
      focusedBorder: _getFocusedBorder(),
      errorBorder: _getErrorBorder(),
      focusedErrorBorder: _getFocusedErrorBorder(),
      disabledBorder: _getDisabledBorder(),
    );
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    if (!widget.showClearButton || !_hasText) {
      return null;
    }

    return IconButton(
      icon: Icon(
        widget.clearIcon ?? Icons.clear,
        size: _getIconSize(),
        color: _getIconColor(theme),
      ),
      onPressed: _clearText,
      tooltip: 'Clear',
    );
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  TextStyle _getTextStyle(ThemeData theme) {
    switch (widget.size) {
      case AppSearchFieldSize.small:
        return AppTextStyles.bodySmall;
      case AppSearchFieldSize.medium:
        return AppTextStyles.bodyMedium;
      case AppSearchFieldSize.large:
        return AppTextStyles.bodyLarge;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AppSearchFieldSize.small:
        return AppSpacing.iconSm;
      case AppSearchFieldSize.medium:
        return AppSpacing.iconMd;
      case AppSearchFieldSize.large:
        return AppSpacing.iconLg;
    }
  }

  Color _getIconColor(ThemeData theme) {
    if (!widget.enabled) {
      return theme.colorScheme.onSurface.withOpacity(0.3);
    }
    if (_hasFocus) {
      return AppColors.primary;
    }
    return theme.colorScheme.onSurfaceVariant;
  }

  EdgeInsets _getContentPadding() {
    switch (widget.size) {
      case AppSearchFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppSearchFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case AppSearchFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  InputBorder _getBorder() {
    switch (widget.variant) {
      case AppSearchFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.outline),
        );
      case AppSearchFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: BorderSide.none,
        );
      case AppSearchFieldVariant.rounded:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.outline),
        );
    }
  }

  InputBorder _getEnabledBorder() {
    switch (widget.variant) {
      case AppSearchFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.outline),
        );
      case AppSearchFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: BorderSide.none,
        );
      case AppSearchFieldVariant.rounded:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.outline),
        );
    }
  }

  InputBorder _getFocusedBorder() {
    switch (widget.variant) {
      case AppSearchFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        );
      case AppSearchFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        );
      case AppSearchFieldVariant.rounded:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        );
    }
  }

  InputBorder _getErrorBorder() {
    switch (widget.variant) {
      case AppSearchFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.error),
        );
      case AppSearchFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.error),
        );
      case AppSearchFieldVariant.rounded:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.error),
        );
    }
  }

  InputBorder _getFocusedErrorBorder() {
    switch (widget.variant) {
      case AppSearchFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        );
      case AppSearchFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        );
      case AppSearchFieldVariant.rounded:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        );
    }
  }

  InputBorder _getDisabledBorder() {
    switch (widget.variant) {
      case AppSearchFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.outline, width: 0.5),
        );
      case AppSearchFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: BorderSide.none,
        );
      case AppSearchFieldVariant.rounded:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          borderSide: const BorderSide(color: AppColors.outline, width: 0.5),
        );
    }
  }

  double _getBorderRadius() {
    switch (widget.variant) {
      case AppSearchFieldVariant.outlined:
        return AppSpacing.radiusMd;
      case AppSearchFieldVariant.filled:
        return AppSpacing.radiusMd;
      case AppSearchFieldVariant.rounded:
        return AppSpacing.radiusXl2;
    }
  }
}

enum AppSearchFieldVariant { outlined, filled, rounded }

enum AppSearchFieldSize { small, medium, large }
