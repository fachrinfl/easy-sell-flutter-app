import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_text.dart';
import '../atoms/app_text_button.dart';

class AuthFooter extends StatelessWidget {
  final String? primaryText;
  final String? secondaryText;
  final String? actionText;
  final VoidCallback? onAction;
  final List<Widget>? links;
  final bool showDivider;

  const AuthFooter({
    super.key,
    this.primaryText,
    this.secondaryText,
    this.actionText,
    this.onAction,
    this.links,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          if (showDivider) ...[
            const Divider(color: AppColors.outline),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (primaryText != null || secondaryText != null) ...[
            _buildTextContent(),
            const SizedBox(height: AppSpacing.md),
          ],
          if (actionText != null && onAction != null) ...[
            _buildActionButton(),
            const SizedBox(height: AppSpacing.md),
          ],
          if (links != null && links!.isNotEmpty) ...[_buildLinks()],
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      children: [
        if (primaryText != null)
          AppText(
            primaryText!,
            variant: AppTextVariant.bodyMedium,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
        if (primaryText != null && secondaryText != null)
          const SizedBox(height: AppSpacing.sm),
        if (secondaryText != null)
          AppText(
            secondaryText!,
            variant: AppTextVariant.bodySmall,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildActionButton() {
    return AppTextButton(actionText!, onPressed: onAction!);
  }

  Widget _buildLinks() {
    return Column(
      children: links!.map((link) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: link,
        );
      }).toList(),
    );
  }
}
