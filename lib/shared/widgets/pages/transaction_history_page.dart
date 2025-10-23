import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/pos/models/transaction.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_icon_button.dart';
import '../atoms/app_search_field.dart';
import '../atoms/app_shimmer.dart';
import '../atoms/app_text.dart';
import '../molecules/app_app_bar.dart';

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState
    extends ConsumerState<TransactionHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSort = 'Newest';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // This method is now just for refresh functionality
    setState(() {});
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: AppText(
            'Transaction History',
            variant: AppTextVariant.titleLarge,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchAndStatsSection(),
            Expanded(child: _buildTransactionsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndStatsSection() {
    return Container(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AppSearchField(
                    controller: _searchController,
                    hint:
                        'Search by transaction number, items, payment method...',
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                AppIconButton(
                  Icons.filter_list,
                  onPressed: _showFilterDialog,
                  tooltip: 'Filter & Sort',
                  variant: AppIconButtonVariant.secondary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildStatsCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    final allTransactionsAsync = ref.watch(transactionsProvider);

    return allTransactionsAsync.when(
      data: (allTransactions) => _buildStatsCardsContent(allTransactions),
      loading: () => _buildStatsCardsShimmer(),
      error: (_, __) => _buildStatsCardsContent([]),
    );
  }

  Widget _buildStatsCardsContent(List<Transaction> allTransactions) {
    final todayTransactions = allTransactions
        .where(
          (txn) =>
              txn.createdAt.day == DateTime.now().day &&
              txn.createdAt.month == DateTime.now().month &&
              txn.createdAt.year == DateTime.now().year,
        )
        .toList();

    final todayTotal = todayTransactions.fold(
      0.0,
      (sum, txn) => sum + txn.total,
    );
    final todayCount = todayTransactions.length;
    final totalTransactions = allTransactions.length;
    final avgOrder = totalTransactions > 0
        ? allTransactions.fold(0.0, (sum, txn) => sum + txn.total) /
              totalTransactions
        : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Today\'s Sales',
                '\$${todayTotal.toStringAsFixed(2)}',
                Icons.today,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildStatCard(
                'Today\'s Orders',
                todayCount.toString(),
                Icons.receipt,
                AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Orders',
                totalTransactions.toString(),
                Icons.history,
                AppColors.tertiary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildStatCard(
                'Avg. Order',
                '\$${avgOrder.toStringAsFixed(2)}',
                Icons.trending_up,
                AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCardsShimmer() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCardShimmer()),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _buildStatCardShimmer()),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: _buildStatCardShimmer()),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _buildStatCardShimmer()),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCardShimmer() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppShimmerContainer(
              width: AppSpacing.iconMd,
              height: AppSpacing.iconMd,
              borderRadius: AppSpacing.iconMd / 2,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppShimmerContainer(width: 80, height: 12, borderRadius: 2),
            const SizedBox(height: AppSpacing.xs),
            AppShimmerContainer(width: 60, height: 16, borderRadius: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSpacing.iconMd, color: color),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              title,
              variant: AppTextVariant.bodySmall,
              color: AppColors.textSecondary,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              value,
              variant: AppTextVariant.titleMedium,
              color: AppColors.textPrimary,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    final allTransactionsAsync = ref.watch(transactionsProvider);

    return allTransactionsAsync.when(
      data: (allTransactions) {
        if (allTransactions.isEmpty) {
          return _buildEmptyState(_searchQuery.isNotEmpty);
        }

        // Apply search filter
        final filteredTransactions = _searchQuery.isNotEmpty
            ? allTransactions.where((transaction) {
                final searchLower = _searchQuery.toLowerCase();
                return transaction.id.toLowerCase().contains(searchLower) ||
                    transaction.items.any(
                      (item) => item.name.toLowerCase().contains(searchLower),
                    ) ||
                    transaction.paymentMethod.toLowerCase().contains(
                      searchLower,
                    ) ||
                    transaction.status.toLowerCase().contains(searchLower);
              }).toList()
            : allTransactions;

        // Apply status filter
        final statusFilteredTransactions = _selectedFilter == 'All'
            ? filteredTransactions
            : filteredTransactions
                  .where((transaction) => transaction.status == _selectedFilter)
                  .toList();

        // Apply sorting
        final sortedTransactions = List<Transaction>.from(
          statusFilteredTransactions,
        );
        switch (_selectedSort) {
          case 'Newest':
            sortedTransactions.sort(
              (a, b) => b.createdAt.compareTo(a.createdAt),
            );
            break;
          case 'Oldest':
            sortedTransactions.sort(
              (a, b) => a.createdAt.compareTo(b.createdAt),
            );
            break;
          case 'Highest Amount':
            sortedTransactions.sort((a, b) => b.total.compareTo(a.total));
            break;
          case 'Lowest Amount':
            sortedTransactions.sort((a, b) => a.total.compareTo(b.total));
            break;
        }

        return RefreshIndicator(
          onRefresh: _loadInitialData,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: sortedTransactions.length,
            itemBuilder: (context, index) {
              final transaction = sortedTransactions[index];
              return _buildTransactionCard(transaction);
            },
          ),
        );
      },
      loading: () => _buildLoadingMoreShimmer(),
      error: (_, __) => _buildEmptyState(false),
    );
  }

  Widget _buildLoadingMoreShimmer() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _buildTransactionCardShimmer(),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCardShimmer() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppShimmerContainer(
                    width: 120,
                    height: 16,
                    borderRadius: 4,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppShimmerContainer(width: 60, height: 20, borderRadius: 10),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppShimmerContainer(width: 100, height: 14, borderRadius: 2),
            const SizedBox(height: AppSpacing.md),
            ...List.generate(
              2,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmerContainer(width: 80, height: 14, borderRadius: 2),
                    AppShimmerContainer(width: 50, height: 14, borderRadius: 2),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerContainer(
                      width: 100,
                      height: 16,
                      borderRadius: 2,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppShimmerContainer(
                      width: 120,
                      height: 12,
                      borderRadius: 2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppShimmerContainer(
                      width: 32,
                      height: 32,
                      borderRadius: 16,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppShimmerContainer(
                      width: 32,
                      height: 32,
                      borderRadius: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final statusColor = _getStatusColor(transaction.status);

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    transaction.id,
                    variant: AppTextVariant.titleMedium,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: AppText(
                    transaction.status,
                    variant: AppTextVariant.caption,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: AppSpacing.iconSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                AppText(
                  _formatDateTime(transaction.createdAt),
                  variant: AppTextVariant.bodyMedium,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...transaction.items.map<Widget>(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      '${item.quantity}x ${item.name}',
                      variant: AppTextVariant.bodyMedium,
                      color: AppColors.textPrimary,
                    ),
                    AppText(
                      '\$${item.subtotal.toStringAsFixed(2)}',
                      variant: AppTextVariant.bodyMedium,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Total: \$${transaction.total.toStringAsFixed(2)}',
                      variant: AppTextVariant.titleMedium,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      '${transaction.paymentMethod} • ${transaction.items.length} items',
                      variant: AppTextVariant.bodySmall,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppIconButton(
                      Icons.copy,
                      onPressed: () => _copyTransactionNumber(transaction),
                      tooltip: 'Copy Transaction Number',
                      size: AppIconButtonSize.small,
                      variant: AppIconButtonVariant.ghost,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppIconButton(
                      Icons.undo,
                      onPressed: transaction.status == 'Completed'
                          ? () => _processRefund(transaction)
                          : null,
                      tooltip: 'Process Refund',
                      size: AppIconButtonSize.small,
                      variant: AppIconButtonVariant.ghost,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.receipt_long,
            size: AppSpacing.xl6,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText(
            isSearching ? 'No transactions found' : 'No transactions found',
            variant: AppTextVariant.titleMedium,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            isSearching
                ? 'Try searching by transaction number, item name, or payment method'
                : 'Transactions will appear here once you start making sales',
            variant: AppTextVariant.bodyMedium,
            color: AppColors.textHint,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.success;
      case 'Refunded':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          title: Row(
            children: [
              Icon(
                Icons.tune,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.sm),
              AppText(
                'Filter & Sort',
                variant: AppTextVariant.titleLarge,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterSection(
                  'Transaction Status',
                  ['All', 'Completed', 'Refunded'],
                  _selectedFilter,
                  (value) {
                    _onFilterChanged(value);
                    setDialogState(() {});
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                _buildFilterSection(
                  'Sort Order',
                  ['Newest', 'Oldest', 'Highest Amount', 'Lowest Amount'],
                  _selectedSort,
                  (value) {
                    setState(() => _selectedSort = value);
                    setDialogState(() {});
                  },
                ),
              ],
            ),
          ),
          actions: [
            AppButton(
              'Apply Filters',
              variant: AppButtonVariant.primary,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selected,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          variant: AppTextVariant.titleMedium,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: options
              .map(
                (option) => GestureDetector(
                  onTap: () => onChanged(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: selected == option
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: selected == option
                            ? AppColors.primary
                            : AppColors.outline,
                        width: selected == option ? 2 : 1,
                      ),
                      boxShadow: selected == option
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selected == option) ...[
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.onPrimary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        AppText(
                          option,
                          variant: AppTextVariant.bodyMedium,
                          color: selected == option
                              ? AppColors.onPrimary
                              : AppColors.textPrimary,
                          fontWeight: selected == option
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _copyTransactionNumber(Transaction transaction) async {
    try {
      await Clipboard.setData(ClipboardData(text: transaction.id));
      _showSnackBar('Transaction number ${transaction.id} copied to clipboard');
    } catch (e) {
      _showSnackBar('Failed to copy transaction number');
    }
  }

  void _processRefund(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Process Refund',
          variant: AppTextVariant.titleLarge,
          color: AppColors.textPrimary,
        ),
        content: AppText(
          'Are you sure you want to refund \$${transaction.total.toStringAsFixed(2)} for ${transaction.id}?',
          variant: AppTextVariant.bodyMedium,
          color: AppColors.textSecondary,
        ),
        actions: [
          AppButton(
            'Cancel',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.pop(context),
          ),
          AppButton(
            'Refund',
            variant: AppButtonVariant.danger,
            onPressed: () async {
              Navigator.pop(context);
              try {
                final transactionService = ref.read(transactionServiceProvider);
                await transactionService.updateTransactionStatus(
                  transaction.id,
                  'Refunded',
                );
                _showSnackBar('Refund processed for ${transaction.id}');
              } catch (e) {
                _showSnackBar('Failed to process refund: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
