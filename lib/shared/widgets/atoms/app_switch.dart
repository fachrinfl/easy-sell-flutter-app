import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'app_text.dart';

class AppSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const AppSwitch({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: AppText(label, variant: AppTextVariant.bodyMedium)),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}
