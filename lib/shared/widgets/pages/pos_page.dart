import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/product_service.dart';
import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/pos/models/product.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_icon_button.dart';
import '../atoms/app_search_field.dart';
import '../atoms/app_text.dart';
import '../molecules/app_app_bar.dart';

class POSPage extends ConsumerStatefulWidget {
  const POSPage({super.key});

  @override
  ConsumerState<POSPage> createState() => _POSPageState();
}

class _POSPageState extends ConsumerState<POSPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<CartItem> _cartItems = [];
  String _searchQuery = '';
  double _subtotal = 0.0;
  double _tax = 0.0;
  double _discount = 0.0;
  double _total = 0.0;
  int _itemCount = 0;
  bool _isProcessingPayment = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(activeProductsProvider);

    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: AppText(
            'Point of Sale',
            variant: AppTextVariant.titleLarge,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: AppIconButton(
              Icons.history,
              onPressed: () => context.pushNamed('transactionHistory'),
              tooltip: 'Transaction History',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppSearchField(
              controller: _searchController,
              hint: 'Search products...',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final availableProducts = products
                    .where((product) => product.stock > 0)
                    .toList();
                final filteredProducts = _searchQuery.isEmpty
                    ? availableProducts
                    : availableProducts
                          .where(
                            (product) =>
                                product.name.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                ) ||
                                product.category.toLowerCase().contains(
                                  _searchQuery.toLowerCase(),
                                ),
                          )
                          .toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppText(
                          _searchQuery.isEmpty
                              ? 'No products available'
                              : 'No products found',
                          variant: AppTextVariant.titleMedium,
                          color: AppColors.textSecondary,
                        ),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          AppText(
                            'Try adjusting your search terms',
                            variant: AppTextVariant.bodyMedium,
                            color: AppColors.textHint,
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(product);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: AppText('Error loading products: $error')),
            ),
          ),
          _buildCartSummary(),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.surface,
      elevation: 2,
      child: InkWell(
        onTap: () => _addToCart(product),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                product.name,
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                '\$${product.price.toStringAsFixed(2)}',
                variant: AppTextVariant.bodyLarge,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                'Stock: ${product.stock}',
                variant: AppTextVariant.caption,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getProductIcon(String category) {
    switch (category.toLowerCase()) {
      case 'beverages':
        return Icons.local_drink;
      case 'food':
        return Icons.restaurant;
      case 'snacks':
        return Icons.cookie;
      case 'desserts':
        return Icons.cake;
      case 'dairy':
        return Icons.water_drop;
      case 'produce':
        return Icons.eco;
      default:
        return Icons.inventory;
    }
  }

  Widget _buildCartSummary() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_cartItems.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Cart (${_cartItems.length} items)',
                      variant: AppTextVariant.titleMedium,
                      color: AppColors.textPrimary,
                    ),
                    Row(
                      children: [
                        AppText(
                          '\$${_total.toStringAsFixed(2)}',
                          variant: AppTextVariant.titleLarge,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AppIconButton(
                          Icons.shopping_cart,
                          onPressed: _showCartItems,
                          tooltip: 'View Cart Items',
                          size: AppIconButtonSize.small,
                          variant: AppIconButtonVariant.ghost,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              Row(
                children: [
                  if (_cartItems.isNotEmpty) ...[
                    Expanded(
                      child: AppButton(
                        'Clear Cart',
                        variant: AppButtonVariant.secondary,
                        onPressed: _clearCart,
                        icon: Icons.clear,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: AppButton(
                      'Process',
                      variant: AppButtonVariant.primary,
                      onPressed: _cartItems.isEmpty ? null : _processPayment,
                      icon: Icons.payment,
                      loading: _isProcessingPayment,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(Product product) {
    setState(() {
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.id == product.id,
      );

      if (existingItemIndex != -1) {
        _cartItems[existingItemIndex].quantity++;
      } else {
        _cartItems.add(
          CartItem(
            id: product.id,
            name: product.name,
            price: product.price,
            quantity: 1,
          ),
        );
      }

      _updateTotals();
    });
  }

  void _updateTotals() {
    _subtotal = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    _tax = _subtotal * 0.08;
    _total = _subtotal + _tax - _discount;
    _itemCount = _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _updateTotals();
    });
  }

  void _processPayment() async {
    if (_cartItems.isEmpty) {
      _showSnackBar('Cart is empty');
      return;
    }

    final paymentMethod = await _showPaymentMethodBottomSheet();
    if (paymentMethod == null) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      await _processTransaction(paymentMethod);

      _showSnackBar('Payment processed successfully!');
    } catch (e) {
      _showSnackBar('Payment failed. Please try again.');
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  Future<String?> _showPaymentMethodBottomSheet() async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Select Payment Method',
                      variant: AppTextVariant.titleLarge,
                      color: AppColors.textPrimary,
                    ),
                    AppIconButton(
                      Icons.close,
                      onPressed: () => Navigator.pop(context),
                      variant: AppIconButtonVariant.ghost,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          'Total Amount',
                          variant: AppTextVariant.bodyLarge,
                          color: AppColors.textPrimary,
                        ),
                        AppText(
                          '\$${_total.toStringAsFixed(2)}',
                          variant: AppTextVariant.titleLarge,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildPaymentMethodOption(
                          'Cash',
                          'Pay with cash',
                          Icons.money,
                          'cash',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildPaymentMethodOption(
                          'Transfer',
                          'Bank transfer or mobile payment',
                          Icons.account_balance,
                          'transfer',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildPaymentMethodOption(
                          'Card',
                          'Credit or debit card',
                          Icons.credit_card,
                          'card',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    String title,
    String subtitle,
    IconData icon,
    String value,
  ) {
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    variant: AppTextVariant.bodyLarge,
                    color: AppColors.textPrimary,
                  ),
                  AppText(
                    subtitle,
                    variant: AppTextVariant.bodySmall,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processTransaction(String paymentMethod) async {
    try {
      final transactionService = ref.read(transactionServiceProvider);

      final now = DateTime.now();
      final transactionId = 'TXN-${now.millisecondsSinceEpoch}';

      final items = _cartItems
          .map(
            (item) => {
              'productId': item.id,
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'subtotal': item.price * item.quantity,
            },
          )
          .toList();

      await transactionService.createTransaction(
        transactionId: transactionId,
        items: items,
        subtotal: _subtotal,
        tax: _tax,
        discount: _discount,
        total: _total,
        paymentMethod: paymentMethod,
        status: 'Completed',
      );

      // Invalidate transaction providers to refresh transaction history
      ref.invalidate(transactionsProvider);
      ref.invalidate(paginatedTransactionsProvider);

      for (final item in _cartItems) {}
      _resetTransaction();
    } catch (e) {
      throw Exception('Failed to process transaction: $e');
    }
  }

  void _resetTransaction() {
    setState(() {
      _cartItems.clear();
      _subtotal = 0.0;
      _tax = 0.0;
      _discount = 0.0;
      _total = 0.0;
      _itemCount = 0;
      _isProcessingPayment = false;
    });
  }

  void _showCartItems() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        'Cart Items',
                        variant: AppTextVariant.titleLarge,
                        color: AppColors.textPrimary,
                      ),
                      AppIconButton(
                        Icons.close,
                        onPressed: () => Navigator.pop(context),
                        variant: AppIconButtonVariant.ghost,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 64,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppText(
                                'Your cart is empty',
                                variant: AppTextVariant.titleMedium,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return _buildCartItemWithModalState(
                              item,
                              setModalState,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.name,
                    variant: AppTextVariant.bodyLarge,
                    color: AppColors.textPrimary,
                  ),
                  AppText(
                    '\$${item.price.toStringAsFixed(2)} each',
                    variant: AppTextVariant.bodySmall,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                AppIconButton(
                  Icons.remove,
                  onPressed: () => _updateQuantity(item.id, -1),
                  size: AppIconButtonSize.small,
                  variant: AppIconButtonVariant.ghost,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: AppText(
                    item.quantity.toString(),
                    variant: AppTextVariant.bodyLarge,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppIconButton(
                  Icons.add,
                  onPressed: () => _updateQuantity(item.id, 1),
                  size: AppIconButtonSize.small,
                  variant: AppIconButtonVariant.ghost,
                ),
                const SizedBox(width: AppSpacing.sm),
                AppIconButton(
                  Icons.delete,
                  onPressed: () => _removeItem(item.id),
                  size: AppIconButtonSize.small,
                  variant: AppIconButtonVariant.ghost,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemWithModalState(
    CartItem item,
    StateSetter setModalState,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.name,
                    variant: AppTextVariant.bodyLarge,
                    color: AppColors.textPrimary,
                  ),
                  AppText(
                    '\$${item.price.toStringAsFixed(2)} each',
                    variant: AppTextVariant.bodySmall,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                AppIconButton(
                  Icons.remove,
                  onPressed: () {
                    _updateQuantity(item.id, -1);
                    setModalState(() {});
                  },
                  size: AppIconButtonSize.small,
                  variant: AppIconButtonVariant.ghost,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: AppText(
                    item.quantity.toString(),
                    variant: AppTextVariant.bodyLarge,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppIconButton(
                  Icons.add,
                  onPressed: () {
                    _updateQuantity(item.id, 1);
                    setModalState(() {});
                  },
                  size: AppIconButtonSize.small,
                  variant: AppIconButtonVariant.ghost,
                ),
                const SizedBox(width: AppSpacing.sm),
                AppIconButton(
                  Icons.delete,
                  onPressed: () {
                    _removeItem(item.id);
                    setModalState(() {});
                  },
                  size: AppIconButtonSize.small,
                  variant: AppIconButtonVariant.ghost,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(String itemId, int change) {
    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex].quantity += change;
        if (_cartItems[itemIndex].quantity <= 0) {
          _cartItems.removeAt(itemIndex);
        }
        _updateTotals();
      }
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
      _updateTotals();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}
