import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_icon_button.dart';
import '../atoms/app_text.dart';

class CartPanel extends StatelessWidget {
  final List<CartItem> items;
  final Function(CartItem)? onItemRemove;
  final Function(CartItem, int)? onItemQuantityChange;
  final VoidCallback? onClearCart;
  final VoidCallback? onCheckout;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final bool showCheckoutButton;
  final bool isLoading;
  final String? checkoutButtonText;

  const CartPanel({
    super.key,
    required this.items,
    this.onItemRemove,
    this.onItemQuantityChange,
    this.onClearCart,
    this.onCheckout,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    this.showCheckoutButton = true,
    this.isLoading = false,
    this.checkoutButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.md),
          _buildItemsList(),
          const SizedBox(height: AppSpacing.md),
          _buildSummary(),
          if (showCheckoutButton) ...[
            const SizedBox(height: AppSpacing.md),
            _buildCheckoutButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          'Shopping Cart',
          variant: AppTextVariant.titleLarge,
          color: AppColors.textPrimary,
        ),
        if (onClearCart != null && items.isNotEmpty)
          AppIconButton(
            Icons.clear_all,
            onPressed: onClearCart,
            tooltip: 'Clear Cart',
          ),
      ],
    );
  }

  Widget _buildItemsList() {
    if (items.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: AppSizes.iconSizeLarge,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              'Cart is empty',
              variant: AppTextVariant.bodyMedium,
              color: AppColors.textHint,
            ),
          ],
        ),
      );
    }

    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildCartItem(item);
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.name,
                  variant: AppTextVariant.bodyMedium,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  '\$${item.price.toStringAsFixed(2)}',
                  variant: AppTextVariant.bodySmall,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          _buildQuantityControls(item),
          const SizedBox(width: AppSpacing.sm),
          AppText(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            variant: AppTextVariant.titleMedium,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: AppSpacing.sm),
          AppIconButton(
            Icons.remove_circle_outline,
            onPressed: () => onItemRemove?.call(item),
            tooltip: 'Remove Item',
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(CartItem item) {
    return Row(
      children: [
        AppIconButton(
          Icons.remove,
          onPressed: item.quantity > 1
              ? () => onItemQuantityChange?.call(item, item.quantity - 1)
              : null,
          tooltip: 'Decrease Quantity',
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: AppText(
            item.quantity.toString(),
            variant: AppTextVariant.bodyMedium,
            color: AppColors.textPrimary,
          ),
        ),
        AppIconButton(
          Icons.add,
          onPressed: () => onItemQuantityChange?.call(item, item.quantity + 1),
          tooltip: 'Increase Quantity',
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      children: [
        _buildSummaryRow('Subtotal', subtotal),
        _buildSummaryRow('Tax', tax),
        if (discount > 0) _buildSummaryRow('Discount', -discount),
        const Divider(color: AppColors.outline),
        _buildSummaryRow('Total', total, isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            variant: isTotal
                ? AppTextVariant.titleMedium
                : AppTextVariant.bodyMedium,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          AppText(
            '\$${amount.toStringAsFixed(2)}',
            variant: isTotal
                ? AppTextVariant.titleLarge
                : AppTextVariant.bodyMedium,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return AppButton(
      checkoutButtonText ?? 'Checkout',
      variant: AppButtonVariant.primary,
      onPressed: items.isNotEmpty && !isLoading ? onCheckout : null,
      loading: isLoading,
      width: double.infinity,
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });
}
