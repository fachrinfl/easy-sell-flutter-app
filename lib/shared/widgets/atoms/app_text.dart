import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class AppText extends StatelessWidget {
  final String text;

  final AppTextVariant variant;

  final Color? color;

  final TextAlign? textAlign;

  final int? maxLines;

  final TextOverflow? overflow;

  final bool selectable;

  final TextDecoration? decoration;

  final FontWeight? fontWeight;

  final double? fontSize;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.selectable = false,
    this.decoration,
    this.fontWeight,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = _getTextStyle(theme);

    final widget = Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    if (selectable) {
      return SelectableText(text, style: textStyle, textAlign: textAlign);
    }

    return widget;
  }

  TextStyle _getTextStyle(ThemeData theme) {
    TextStyle baseStyle;

    switch (variant) {
      case AppTextVariant.displayLarge:
        baseStyle = AppTextStyles.displayLarge;
        break;
      case AppTextVariant.displayMedium:
        baseStyle = AppTextStyles.displayMedium;
        break;
      case AppTextVariant.displaySmall:
        baseStyle = AppTextStyles.displaySmall;
        break;
      case AppTextVariant.headlineLarge:
        baseStyle = AppTextStyles.headlineLarge;
        break;
      case AppTextVariant.headlineMedium:
        baseStyle = AppTextStyles.headlineMedium;
        break;
      case AppTextVariant.headlineSmall:
        baseStyle = AppTextStyles.headlineSmall;
        break;
      case AppTextVariant.titleLarge:
        baseStyle = AppTextStyles.titleLarge;
        break;
      case AppTextVariant.titleMedium:
        baseStyle = AppTextStyles.titleMedium;
        break;
      case AppTextVariant.titleSmall:
        baseStyle = AppTextStyles.titleSmall;
        break;
      case AppTextVariant.bodyLarge:
        baseStyle = AppTextStyles.bodyLarge;
        break;
      case AppTextVariant.bodyMedium:
        baseStyle = AppTextStyles.bodyMedium;
        break;
      case AppTextVariant.bodySmall:
        baseStyle = AppTextStyles.bodySmall;
        break;
      case AppTextVariant.labelLarge:
        baseStyle = AppTextStyles.labelLarge;
        break;
      case AppTextVariant.labelMedium:
        baseStyle = AppTextStyles.labelMedium;
        break;
      case AppTextVariant.labelSmall:
        baseStyle = AppTextStyles.labelSmall;
        break;
      case AppTextVariant.buttonLarge:
        baseStyle = AppTextStyles.buttonLarge;
        break;
      case AppTextVariant.buttonMedium:
        baseStyle = AppTextStyles.buttonMedium;
        break;
      case AppTextVariant.buttonSmall:
        baseStyle = AppTextStyles.buttonSmall;
        break;
      case AppTextVariant.caption:
        baseStyle = AppTextStyles.caption;
        break;
      case AppTextVariant.overline:
        baseStyle = AppTextStyles.overline;
        break;
    }

    return baseStyle.copyWith(
      color: color ?? theme.colorScheme.onSurface,
      fontWeight: fontWeight,
      fontSize: fontSize,
      decoration: decoration,
    );
  }
}

enum AppTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  buttonLarge,
  buttonMedium,
  buttonSmall,
  caption,
  overline,
}
