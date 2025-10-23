import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_badge.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_shimmer.dart';
import '../atoms/app_text.dart';
import '../molecules/app_app_bar.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: AppText(
            'Reports & Analytics',
            variant: AppTextVariant.titleLarge,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSalesSummary(ref),
              const SizedBox(height: AppSpacing.xl),
              _buildTopProducts(ref),
              const SizedBox(height: AppSpacing.xl),
              _buildRecentSales(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesSummary(WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final weekStart = today.subtract(Duration(days: now.weekday - 1));
        final monthStart = DateTime(now.year, now.month, 1);
        final yearStart = DateTime(now.year, 1, 1);

        final todayTransactions = transactions
            .where((t) => t.createdAt.isAfter(today) && t.status == 'Completed')
            .toList();
        final weekTransactions = transactions
            .where(
              (t) => t.createdAt.isAfter(weekStart) && t.status == 'Completed',
            )
            .toList();
        final monthTransactions = transactions
            .where(
              (t) => t.createdAt.isAfter(monthStart) && t.status == 'Completed',
            )
            .toList();
        final yearTransactions = transactions
            .where(
              (t) => t.createdAt.isAfter(yearStart) && t.status == 'Completed',
            )
            .toList();

        final todayTotal = todayTransactions.fold(
          0.0,
          (sum, t) => sum + t.total,
        );
        final weekTotal = weekTransactions.fold(0.0, (sum, t) => sum + t.total);
        final monthTotal = monthTransactions.fold(
          0.0,
          (sum, t) => sum + t.total,
        );
        final yearTotal = yearTransactions.fold(0.0, (sum, t) => sum + t.total);

        return AppCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText('Sales Summary', variant: AppTextVariant.titleLarge),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Today',
                        '\$${todayTotal.toStringAsFixed(2)}',
                        '${todayTransactions.length} sales',
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildSummaryCard(
                        'This Week',
                        '\$${weekTotal.toStringAsFixed(2)}',
                        '${weekTransactions.length} sales',
                        AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'This Month',
                        '\$${monthTotal.toStringAsFixed(2)}',
                        '${monthTransactions.length} sales',
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildSummaryCard(
                        'This Year',
                        '\$${yearTotal.toStringAsFixed(2)}',
                        '${yearTransactions.length} sales',
                        AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => _buildSalesSummaryShimmer(),
      error: (error, stack) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              AppText('Sales Summary', variant: AppTextVariant.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              AppText('Error loading data: $error', color: AppColors.error),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String period,
    String amount,
    String sales,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            period,
            variant: AppTextVariant.bodySmall,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(amount, variant: AppTextVariant.titleLarge, color: color),
          AppText(
            sales,
            variant: AppTextVariant.caption,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts(WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        final Map<String, Map<String, dynamic>> productSales = {};

        for (final transaction in transactions.where(
          (t) => t.status == 'Completed',
        )) {
          for (final item in transaction.items) {
            final productId = item.productId;
            if (productSales.containsKey(productId)) {
              productSales[productId]!['quantity'] += item.quantity;
              productSales[productId]!['revenue'] += item.subtotal;
            } else {
              productSales[productId] = {
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
                'revenue': item.subtotal,
              };
            }
          }
        }

        final sortedProducts = productSales.entries.toList()
          ..sort((a, b) => b.value['quantity'].compareTo(a.value['quantity']));

        return AppCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText('Top Products', variant: AppTextVariant.titleLarge),
                const SizedBox(height: AppSpacing.lg),
                if (sortedProducts.isEmpty)
                  AppText(
                    'No sales data available',
                    color: AppColors.textSecondary,
                  )
                else
                  ...sortedProducts.take(4).toList().asMap().entries.map((
                    entry,
                  ) {
                    final index = entry.key;
                    final product = entry.value.value;
                    return _buildProductItem(
                      product['name'],
                      '\$${product['price'].toStringAsFixed(2)}',
                      '${product['quantity']} sold',
                      index + 1,
                    );
                  }).toList(),
              ],
            ),
          ),
        );
      },
      loading: () => _buildTopProductsShimmer(),
      error: (error, stack) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              AppText('Top Products', variant: AppTextVariant.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              AppText('Error loading data: $error', color: AppColors.error),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(String name, String price, String sold, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Center(
              child: AppText(
                rank.toString(),
                variant: AppTextVariant.caption,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(name, variant: AppTextVariant.bodyMedium),
                AppText(
                  price,
                  variant: AppTextVariant.bodySmall,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          AppText(
            sold,
            variant: AppTextVariant.bodySmall,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSales(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        final recentTransactions =
            transactions.where((t) => t.status == 'Completed').toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return AppCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText('Recent Sales', variant: AppTextVariant.titleLarge),
                    const Spacer(),
                    AppButton(
                      'View All',
                      variant: AppButtonVariant.text,
                      onPressed: () =>
                          _showSnackBar(context, 'Viewing all sales'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                if (recentTransactions.isEmpty)
                  AppText('No recent sales', color: AppColors.textSecondary)
                else
                  ...recentTransactions.take(4).map((transaction) {
                    final timeAgo = _getTimeAgo(transaction.createdAt);
                    return _buildSaleItem(
                      transaction.id,
                      '\$${transaction.total.toStringAsFixed(2)}',
                      timeAgo,
                      transaction.status,
                    );
                  }).toList(),
              ],
            ),
          ),
        );
      },
      loading: () => _buildRecentSalesShimmer(),
      error: (error, stack) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              AppText('Recent Sales', variant: AppTextVariant.titleLarge),
              const SizedBox(height: AppSpacing.lg),
              AppText('Error loading data: $error', color: AppColors.error),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaleItem(
    String saleId,
    String amount,
    String time,
    String status,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(saleId, variant: AppTextVariant.bodyMedium),
                AppText(
                  time,
                  variant: AppTextVariant.caption,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          AppText(
            amount,
            variant: AppTextVariant.titleSmall,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          AppBadge(
            status,
            variant: AppBadgeVariant.success,
            size: AppBadgeSize.small,
          ),
        ],
      ),
    );
  }

  VoidCallback _createSnackBarCallback(BuildContext context, String message) {
    return () => _showSnackBar(context, message);
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSalesSummaryShimmer() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmerContainer(width: 120, height: 24, borderRadius: 4),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(child: _buildSummaryCardShimmer()),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildSummaryCardShimmer()),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(child: _buildSummaryCardShimmer()),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildSummaryCardShimmer()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerContainer(width: 60, height: 12, borderRadius: 2),
          const SizedBox(height: AppSpacing.xs),
          AppShimmerContainer(width: 80, height: 20, borderRadius: 4),
          const SizedBox(height: AppSpacing.xs),
          AppShimmerContainer(width: 50, height: 10, borderRadius: 2),
        ],
      ),
    );
  }

  Widget _buildTopProductsShimmer() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmerContainer(width: 100, height: 24, borderRadius: 4),
            const SizedBox(height: AppSpacing.lg),
            ...List.generate(4, (index) => _buildProductItemShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItemShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          AppShimmerContainer(
            width: 24,
            height: 24,
            borderRadius: AppSpacing.radiusSm,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerContainer(width: 120, height: 16, borderRadius: 2),
                const SizedBox(height: AppSpacing.xs),
                AppShimmerContainer(width: 60, height: 12, borderRadius: 2),
              ],
            ),
          ),
          AppShimmerContainer(width: 50, height: 12, borderRadius: 2),
        ],
      ),
    );
  }

  Widget _buildRecentSalesShimmer() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppShimmerContainer(width: 100, height: 24, borderRadius: 4),
                const Spacer(),
                AppShimmerContainer(width: 60, height: 20, borderRadius: 4),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...List.generate(4, (index) => _buildSaleItemShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleItemShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerContainer(width: 100, height: 16, borderRadius: 2),
                const SizedBox(height: AppSpacing.xs),
                AppShimmerContainer(width: 80, height: 12, borderRadius: 2),
              ],
            ),
          ),
          AppShimmerContainer(width: 60, height: 16, borderRadius: 2),
          const SizedBox(width: AppSpacing.md),
          AppShimmerContainer(width: 60, height: 20, borderRadius: 10),
        ],
      ),
    );
  }
}
