import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'app_text.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;

  final String? helperText;

  final String? errorText;

  final String? initialValue;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final int? maxLines;

  final int? maxLength;

  final bool enabled;

  final bool readOnly;

  final bool obscureText;

  final bool autofocus;

  final IconData? prefixIcon;

  final IconData? suffixIcon;

  final Widget? suffix;

  final Widget? prefix;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onTap;

  final String? Function(String?)? validator;

  final List<TextInputFormatter>? inputFormatters;

  final TextCapitalization textCapitalization;

  final TextDirection? textDirection;

  final TextAlign textAlign;

  final AppTextFieldVariant variant;

  final AppTextFieldSize size;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.prefix,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.variant = AppTextFieldVariant.outlined,
    this.size = AppTextFieldSize.medium,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.obscureText != oldWidget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = _buildInputDecoration(theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AppText(
            widget.label!,
            variant: AppTextVariant.labelMedium,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          style: _getTextStyle(theme),
          decoration: decoration,
        ),
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: AppSpacing.xs),
          AppText(
            widget.helperText!,
            variant: AppTextVariant.caption,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          AppText(
            widget.errorText!,
            variant: AppTextVariant.caption,
            color: AppColors.error,
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme) {
    final baseDecoration = InputDecoration(
      hintText: widget.hint,
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              size: _getIconSize(),
              color: _getIconColor(theme),
            )
          : widget.prefix,
      suffixIcon: _buildSuffixIcon(theme),
      contentPadding: _getContentPadding(),
      filled: widget.variant == AppTextFieldVariant.filled,
      border: _getBorder(),
      enabledBorder: _getEnabledBorder(),
      focusedBorder: _getFocusedBorder(),
      errorBorder: _getErrorBorder(),
      focusedErrorBorder: _getFocusedErrorBorder(),
      disabledBorder: _getDisabledBorder(),
    );

    return baseDecoration;
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    if (widget.suffix != null) {
      return widget.suffix;
    }

    if (widget.suffixIcon != null) {
      return Icon(
        widget.suffixIcon,
        size: _getIconSize(),
        color: _getIconColor(theme),
      );
    }

    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          size: _getIconSize(),
          color: _getIconColor(theme),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return null;
  }

  TextStyle _getTextStyle(ThemeData theme) {
    switch (widget.size) {
      case AppTextFieldSize.small:
        return AppTextStyles.bodySmall;
      case AppTextFieldSize.medium:
        return AppTextStyles.bodyMedium;
      case AppTextFieldSize.large:
        return AppTextStyles.bodyLarge;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AppTextFieldSize.small:
        return AppSpacing.iconSm;
      case AppTextFieldSize.medium:
        return AppSpacing.iconMd;
      case AppTextFieldSize.large:
        return AppSpacing.iconLg;
    }
  }

  Color _getIconColor(ThemeData theme) {
    if (!widget.enabled) {
      return theme.colorScheme.onSurface.withOpacity(0.3);
    }
    return theme.colorScheme.onSurfaceVariant;
  }

  EdgeInsets _getContentPadding() {
    switch (widget.size) {
      case AppTextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppTextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case AppTextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  InputBorder _getBorder() {
    switch (widget.variant) {
      case AppTextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.outline),
        );
      case AppTextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        );
      case AppTextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: const BorderSide(color: AppColors.outline),
        );
    }
  }

  InputBorder _getEnabledBorder() {
    switch (widget.variant) {
      case AppTextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.outline),
        );
      case AppTextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        );
      case AppTextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: const BorderSide(color: AppColors.outline),
        );
    }
  }

  InputBorder _getFocusedBorder() {
    switch (widget.variant) {
      case AppTextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        );
      case AppTextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        );
      case AppTextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        );
    }
  }

  InputBorder _getErrorBorder() {
    switch (widget.variant) {
      case AppTextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        );
      case AppTextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        );
      case AppTextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error),
        );
    }
  }

  InputBorder _getFocusedErrorBorder() {
    switch (widget.variant) {
      case AppTextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        );
      case AppTextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        );
      case AppTextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        );
    }
  }

  InputBorder _getDisabledBorder() {
    switch (widget.variant) {
      case AppTextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.outline, width: 0.5),
        );
      case AppTextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide.none,
        );
      case AppTextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: const BorderSide(color: AppColors.outline, width: 0.5),
        );
    }
  }
}

enum AppTextFieldVariant { outlined, filled, underlined }

enum AppTextFieldSize { small, medium, large }
