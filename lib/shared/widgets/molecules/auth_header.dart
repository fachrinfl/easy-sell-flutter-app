import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_text.dart';

class AuthHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? logo;
  final bool showLogo;
  final VoidCallback? onBack;

  const AuthHeader({
    super.key,
    this.title,
    this.subtitle,
    this.logo,
    this.showLogo = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          if (onBack != null) ...[
            Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.textPrimary,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (showLogo) ...[
            _buildLogo(),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (title != null) ...[
            AppText(
              title!,
              variant: AppTextVariant.headlineMedium,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (subtitle != null) ...[
            AppText(
              subtitle!,
              variant: AppTextVariant.bodyLarge,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogo() {
    if (logo != null) {
      return logo!;
    }

    return Container(
      width: AppSizes.iconSizeXLarge * 2,
      height: AppSizes.iconSizeXLarge * 2,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: AppSizes.shadowBlurRadius,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.point_of_sale,
        size: AppSizes.iconSizeXLarge,
        color: AppColors.onPrimary,
      ),
    );
  }
}
