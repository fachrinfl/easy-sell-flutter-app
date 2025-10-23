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
import '../atoms/app_icon_button.dart';
import '../atoms/app_shimmer.dart';
import '../atoms/app_text.dart';
import '../molecules/app_app_bar.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(productStatsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: AppText(
            'Inventory Management',
            variant: AppTextVariant.titleLarge,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: AppIconButton(
              Icons.add,
              onPressed: () => _navigateToAddProduct(),
              tooltip: 'Add Product',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStockSummary(),
              const SizedBox(height: AppSpacing.xl),
              _buildInventoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockSummary() {
    final statsAsync = ref.watch(productStatsProvider);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Stock Summary', variant: AppTextVariant.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      'Total Products',
                      stats.totalProducts.toString(),
                      Icons.inventory,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.outline),
                  Expanded(
                    child: _buildSummaryItem(
                      'Low Stock',
                      stats.lowStock.toString(),
                      Icons.warning,
                      color: AppColors.warning,
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.outline),
                  Expanded(
                    child: _buildSummaryItem(
                      'Out of Stock',
                      stats.outOfStock.toString(),
                      Icons.error,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              loading: () => _buildStockSummaryShimmer(),
              error: (error, stack) => AppText(
                'Error loading stats: $error',
                variant: AppTextVariant.bodySmall,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    final itemColor = color ?? AppColors.primary;
    return Column(
      children: [
        Icon(icon, color: itemColor),
        const SizedBox(height: AppSpacing.xs),
        AppText(value, variant: AppTextVariant.titleLarge, color: itemColor),
        AppText(
          label,
          variant: AppTextVariant.caption,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildStockSummaryShimmer() {
    return Row(
      children: [
        Expanded(child: _buildSummaryItemShimmer()),
        Container(width: 1, height: 40, color: AppColors.outline),
        Expanded(child: _buildSummaryItemShimmer()),
        Container(width: 1, height: 40, color: AppColors.outline),
        Expanded(child: _buildSummaryItemShimmer()),
      ],
    );
  }

  Widget _buildSummaryItemShimmer() {
    return Column(
      children: [
        AppShimmerContainer(
          width: AppSpacing.iconMd,
          height: AppSpacing.iconMd,
          borderRadius: AppSpacing.iconMd / 2,
        ),
        const SizedBox(height: AppSpacing.xs),
        AppShimmerContainer(width: 40, height: 20, borderRadius: 4),
        const SizedBox(height: AppSpacing.xs),
        AppShimmerContainer(width: 60, height: 12, borderRadius: 2),
      ],
    );
  }

  Widget _buildProductListShimmer() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.sm,
          ),
          child: _buildProductItemShimmer(),
        ),
      ),
    );
  }

  Widget _buildProductItemShimmer() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmerContainer(width: 120, height: 16, borderRadius: 2),
              const SizedBox(height: AppSpacing.xs),
              AppShimmerContainer(width: 60, height: 14, borderRadius: 2),
              const SizedBox(height: AppSpacing.xs),
              AppShimmerContainer(width: 80, height: 12, borderRadius: 2),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppShimmerContainer(width: 50, height: 14, borderRadius: 2),
            const SizedBox(height: AppSpacing.xs),
            AppShimmerContainer(width: 40, height: 12, borderRadius: 2),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        AppShimmerContainer(width: 80, height: 24, borderRadius: 12),
      ],
    );
  }

  Widget _buildInventoryList() {
    final productsAsync = ref.watch(productsProvider);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Product Inventory', variant: AppTextVariant.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return _buildEmptyState();
                }

                final filteredProducts = _searchQuery.isEmpty
                    ? products
                    : products
                          .where(
                            (product) =>
                                product.name.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                ) ||
                                product.sku.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                ) ||
                                product.category.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                ),
                          )
                          .toList();

                return Column(
                  children: filteredProducts.map<Widget>((product) {
                    return _buildProductItem(product);
                  }).toList(),
                );
              },
              loading: () => _buildProductListShimmer(),
              error: (error, stack) => AppText(
                'Error loading products: $error',
                variant: AppTextVariant.bodySmall,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.lg),
          AppText(
            'No products found',
            variant: AppTextVariant.titleMedium,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            'Add your first product to get started',
            variant: AppTextVariant.bodyMedium,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            'Add Product',
            variant: AppButtonVariant.primary,
            onPressed: () => _navigateToAddProduct(),
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return InkWell(
      onTap: () => _navigateToViewProduct(product),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(product.name, variant: AppTextVariant.bodyMedium),
                  AppText(
                    '\$${product.price.toStringAsFixed(2)}',
                    variant: AppTextVariant.bodySmall,
                    color: AppColors.textSecondary,
                  ),
                  AppText(
                    product.category,
                    variant: AppTextVariant.caption,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  'Stock: ${product.stock}',
                  variant: AppTextVariant.bodySmall,
                  color: AppColors.textSecondary,
                ),
                AppText(
                  'Min: ${product.minStock}',
                  variant: AppTextVariant.caption,
                  color: AppColors.textHint,
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            _buildStockStatus(product.stock, product.minStock),
          ],
        ),
      ),
    );
  }

  Widget _buildStockStatus(int stock, int minStock) {
    if (stock == 0) {
      return AppBadge(
        'Out of Stock',
        variant: AppBadgeVariant.error,
        size: AppBadgeSize.small,
      );
    } else if (stock <= minStock) {
      return AppBadge(
        'Low Stock',
        variant: AppBadgeVariant.warning,
        size: AppBadgeSize.small,
      );
    } else {
      return AppBadge(
        'In Stock',
        variant: AppBadgeVariant.success,
        size: AppBadgeSize.small,
      );
    }
  }

  void _navigateToAddProduct() {
    context.push('/home/inventory/add-product');
  }

  void _navigateToViewProduct(Product product) {
    context.push('/home/inventory/view-product', extra: product);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
