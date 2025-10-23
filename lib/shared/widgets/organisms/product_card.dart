import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_sizes.dart';
import '../atoms/app_text.dart';
import '../atoms/app_card.dart';
import '../atoms/app_badge.dart';
import '../atoms/app_icon_button.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int? stock;
  final String? category;
  final bool isOnSale;
  final double? salePrice;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddToCart;
  final AppProductCardVariant variant;
  final bool showActions;
  final bool showStock;
  final bool showCategory;

  const ProductCard({
    super.key,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.stock,
    this.category,
    this.isOnSale = false,
    this.salePrice,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onAddToCart,
    this.variant = AppProductCardVariant.standard,
    this.showActions = true,
    this.showStock = true,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          const SizedBox(height: AppSpacing.md),
          _buildContent(),
          if (showActions) ...[
            const SizedBox(height: AppSpacing.md),
            _buildActions(),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: _getImageHeight(),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
      ),
      child: const Icon(
        Icons.image,
        size: AppSizes.iconSizeLarge,
        color: AppColors.textHint,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCategory && category != null) ...[
          AppBadge(
            category!,
            variant: AppBadgeVariant.info,
            size: AppBadgeSize.small,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        AppText(
          name,
          variant: AppTextVariant.titleMedium,
          color: AppColors.textPrimary,
        ),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          AppText(
            description!,
            variant: AppTextVariant.bodySmall,
            color: AppColors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        _buildPrice(),
        if (showStock && stock != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildStock(),
        ],
      ],
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        AppText(
          '\$${price.toStringAsFixed(2)}',
          variant: AppTextVariant.titleLarge,
          color: AppColors.textPrimary,
        ),
        if (isOnSale && salePrice != null) ...[
          const SizedBox(width: AppSpacing.sm),
          AppText(
            '\$${salePrice!.toStringAsFixed(2)}',
            variant: AppTextVariant.bodyMedium,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          AppBadge(
            'Sale',
            variant: AppBadgeVariant.error,
            size: AppBadgeSize.small,
          ),
        ],
      ],
    );
  }

  Widget _buildStock() {
    final stockLevel = _getStockLevel();
    return Row(
      children: [
        Icon(
          _getStockIcon(),
          size: AppSizes.iconSizeSmall,
          color: _getStockColor(),
        ),
        const SizedBox(width: AppSpacing.xs),
        AppText(
          'Stock: $stock',
          variant: AppTextVariant.bodySmall,
          color: _getStockColor(),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onAddToCart != null)
          AppIconButton(
            Icons.add_shopping_cart,
            onPressed: onAddToCart,
            tooltip: 'Add to Cart',
          ),
        const Spacer(),
        if (onEdit != null)
          AppIconButton(
            Icons.edit,
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
        if (onDelete != null)
          AppIconButton(
            Icons.delete,
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
      ],
    );
  }

  double _getImageHeight() {
    switch (variant) {
      case AppProductCardVariant.standard:
        return 120;
      case AppProductCardVariant.compact:
        return 80;
      case AppProductCardVariant.large:
        return 160;
    }
  }

  AppBadgeVariant _getStockLevel() {
    if (stock == null) return AppBadgeVariant.info;
    if (stock! <= 0) return AppBadgeVariant.error;
    if (stock! <= 10) return AppBadgeVariant.warning;
    return AppBadgeVariant.success;
  }

  IconData _getStockIcon() {
    if (stock == null) return Icons.help;
    if (stock! <= 0) return Icons.cancel;
    if (stock! <= 10) return Icons.warning;
    return Icons.check_circle;
  }

  Color _getStockColor() {
    if (stock == null) return AppColors.textHint;
    if (stock! <= 0) return AppColors.error;
    if (stock! <= 10) return AppColors.warning;
    return AppColors.success;
  }
}

enum AppProductCardVariant {
  standard,
  compact,
  large,
}