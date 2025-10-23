import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/atoms/app_text.dart';
import '../../../shared/widgets/atoms/app_text_button.dart';
import '../../../shared/widgets/molecules/auth_footer.dart';
import '../../../shared/widgets/molecules/auth_header.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AuthHeader(
                      title: 'Welcome to EasySell POS',
                      subtitle:
                          'Your complete point-of-sale solution for small businesses',
                      showLogo: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildFeaturesList(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildBenefitsSection(),
                  ],
                ),
              ),
            ),
            AuthFooter(
              primaryText: 'Ready to get started?',
              actionText: 'Get Started',
              onAction: () => context.go('/register'),
              links: [
                AppTextButton(
                  'Already have an account? Sign In',
                  onPressed: () => context.go('/login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.point_of_sale,
        'title': 'Easy Point of Sale',
        'description': 'Process sales quickly and efficiently',
      },
      {
        'icon': Icons.inventory,
        'title': 'Inventory Management',
        'description': 'Track stock levels and manage products',
      },
      {
        'icon': Icons.analytics,
        'title': 'Sales Analytics',
        'description': 'Get insights into your business performance',
      },
      {
        'icon': Icons.receipt,
        'title': 'Digital Receipts',
        'description': 'Generate and email receipts to customers',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        feature['title'] as String,
                        variant: AppTextVariant.titleMedium,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        feature['description'] as String,
                        variant: AppTextVariant.bodyMedium,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          AppText(
            'Why Choose EasySell POS?',
            variant: AppTextVariant.titleLarge,
            color: AppColors.onPrimaryContainer,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            '• No setup fees or monthly subscriptions\n'
            '• Works offline when internet is unavailable\n'
            '• Easy to use interface for all skill levels\n'
            '• Secure cloud backup of your data\n'
            '• 24/7 customer support',
            variant: AppTextVariant.bodyMedium,
            color: AppColors.onPrimaryContainer,
          ),
        ],
      ),
    );
  }
}
