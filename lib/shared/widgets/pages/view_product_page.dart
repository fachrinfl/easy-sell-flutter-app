import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/product_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/pos/models/product.dart';
import '../atoms/app_badge.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_text.dart';
import '../molecules/app_app_bar.dart';

class ViewProductPage extends ConsumerWidget {
  final Map<String, dynamic> product;

  const ViewProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = product['id'] as String?;

    final productAsync = productId != null
        ? ref.watch(productByIdStreamProvider(productId))
        : AsyncValue.error('Product ID not found', StackTrace.current);

    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: AppText(
            'Product Details',
            variant: AppTextVariant.titleLarge,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: productAsync.when(
          data: (currentProduct) {
            if (currentProduct == null) {
              return const Center(child: AppText('Product not found'));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductInfo(currentProduct),
                  const SizedBox(height: AppSpacing.xl),
                  _buildStockInfo(currentProduct),
                  const SizedBox(height: AppSpacing.xl),
                  _buildActionButtons(context, currentProduct),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText('Error loading product: $error'),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  'Retry',
                  onPressed: () =>
                      ref.invalidate(productByIdProvider(productId!)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product currentProduct) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Product Information', variant: AppTextVariant.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            _buildInfoRow('Name', currentProduct.name),
            _buildInfoRow(
              'Price',
              '\$${currentProduct.price.toStringAsFixed(2)}',
            ),
            _buildInfoRow('Category', currentProduct.category),
            if (currentProduct.description.isNotEmpty)
              _buildInfoRow('Description', currentProduct.description),
          ],
        ),
      ),
    );
  }

  Widget _buildStockInfo(Product currentProduct) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Stock Information', variant: AppTextVariant.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            _buildInfoRow('Current Stock', currentProduct.stock.toString()),
            _buildInfoRow('Minimum Stock', currentProduct.minStock.toString()),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                AppText('Status: ', variant: AppTextVariant.bodyMedium),
                _buildStockStatus(
                  currentProduct.stock,
                  currentProduct.minStock,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: AppText(
              label,
              variant: AppTextVariant.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: AppText(
              value,
              variant: AppTextVariant.bodyMedium,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockStatus(int stock, int minStock) {
    if (stock == 0) {
      return AppBadge(
        'Out of Stock',
        variant: AppBadgeVariant.error,
        size: AppBadgeSize.medium,
      );
    } else if (stock <= minStock) {
      return AppBadge(
        'Low Stock',
        variant: AppBadgeVariant.warning,
        size: AppBadgeSize.medium,
      );
    } else {
      return AppBadge(
        'In Stock',
        variant: AppBadgeVariant.success,
        size: AppBadgeSize.medium,
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, Product currentProduct) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        'Edit Product',
        variant: AppButtonVariant.primary,
        onPressed: () => _navigateToEdit(context, currentProduct),
        icon: Icons.edit,
      ),
    );
  }

  void _navigateToEdit(BuildContext context, Product currentProduct) {
    context.pushNamed('editProduct', extra: currentProduct);
  }
}
