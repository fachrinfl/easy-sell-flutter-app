import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/transaction_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_shimmer.dart';
import '../atoms/app_text.dart';
import '../molecules/app_bottom_navigation.dart';
import 'inventory_page.dart';
import 'pos_page.dart';
import 'reports_page.dart';
import 'settings_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        items: const [
          AppBottomNavigationItem(icon: Icons.home, label: 'Home'),
          AppBottomNavigationItem(icon: Icons.point_of_sale, label: 'POS'),
          AppBottomNavigationItem(icon: Icons.inventory, label: 'Inventory'),
          AppBottomNavigationItem(icon: Icons.analytics, label: 'Reports'),
          AppBottomNavigationItem(icon: Icons.settings, label: 'Settings'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildAnalyticsChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl2),
      child: AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Welcome to EasySell POS',
                variant: AppTextVariant.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'Your complete point-of-sale solution for small businesses',
                variant: AppTextVariant.bodyLarge,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.lg),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      'Start Selling',
                      variant: AppButtonVariant.primary,
                      onPressed: () => setState(() => _currentIndex = 1),
                      icon: Icons.point_of_sale,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      'Manage Inventory',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => setState(() => _currentIndex = 2),
                      icon: Icons.inventory,
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

  Widget _buildPOSPage() {
    return POSPage();
  }

  Widget _buildInventoryPage() {
    return const InventoryPage();
  }

  Widget _buildReportsPage() {
    return const ReportsPage();
  }

  Widget _buildSettingsPage() {
    return const SettingsPage();
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return POSPage();
      case 2:
        return InventoryPage();
      case 3:
        return ReportsPage();
      case 4:
        return SettingsPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildAnalyticsChart() {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        final now = DateTime.now();
        final last7Days = List.generate(7, (index) {
          final date = now.subtract(Duration(days: 6 - index));
          final dayStart = DateTime(date.year, date.month, date.day);
          final dayEnd = dayStart.add(Duration(days: 1));

          final dayTransactions = transactions
              .where(
                (t) =>
                    t.createdAt.isAfter(dayStart) &&
                    t.createdAt.isBefore(dayEnd) &&
                    t.status == 'Completed',
              )
              .toList();

          final dayTotal = dayTransactions.fold(0.0, (sum, t) => sum + t.total);

          return {
            'date': date,
            'total': dayTotal,
            'count': dayTransactions.length,
          };
        });

        final maxTotal = last7Days
            .map((d) => d['total'] as double)
            .reduce((a, b) => a > b ? a : b);

        return AppCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        'Sales Trend (Last 7 Days)',
                        variant: AppTextVariant.titleLarge,
                      ),
                    ),
                    AppText(
                      'Total: \$${last7Days.fold(0.0, (sum, d) => sum + (d['total'] as double)).toStringAsFixed(2)}',
                      variant: AppTextVariant.bodyMedium,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: last7Days.map((dayData) {
                      final height = maxTotal > 0
                          ? (dayData['total'] as double) / maxTotal
                          : 0.0;
                      final dayName = _getDayName(dayData['date'] as DateTime);
                      final total = dayData['total'] as double;
                      final count = dayData['count'] as int;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 120 * height,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: total > 0
                                      ? AppText(
                                          '\$${total.toStringAsFixed(0)}',
                                          variant: AppTextVariant.caption,
                                          color: AppColors.onPrimary,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              AppText(
                                dayName,
                                variant: AppTextVariant.caption,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              AppText(
                                '$count sales',
                                variant: AppTextVariant.caption,
                                color: AppColors.textHint,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Avg/Day',
                        '\$${(last7Days.fold(0.0, (sum, d) => sum + (d['total'] as double)) / 7).toStringAsFixed(2)}',
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Best Day',
                        '\$${last7Days.map((d) => d['total'] as double).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}',
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Total Sales',
                        '${last7Days.fold(0, (sum, d) => sum + (d['count'] as int))}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmerContainer(width: 200, height: 24, borderRadius: 4),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(7, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppShimmerContainer(
                              width: double.infinity,
                              height: 120 * (0.3 + (index * 0.1)),
                              borderRadius: 4,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            AppShimmerContainer(
                              width: 30,
                              height: 12,
                              borderRadius: 2,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            AppShimmerContainer(
                              width: 40,
                              height: 10,
                              borderRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        AppShimmerContainer(
                          width: 60,
                          height: 16,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppShimmerContainer(
                          width: 40,
                          height: 12,
                          borderRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        AppShimmerContainer(
                          width: 60,
                          height: 16,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppShimmerContainer(
                          width: 50,
                          height: 12,
                          borderRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        AppShimmerContainer(
                          width: 40,
                          height: 16,
                          borderRadius: 4,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppShimmerContainer(
                          width: 60,
                          height: 12,
                          borderRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              AppText(
                'Sales Trend (Last 7 Days)',
                variant: AppTextVariant.titleLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppText('Error loading data: $error', color: AppColors.error),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        AppText(
          value,
          variant: AppTextVariant.titleMedium,
          color: AppColors.primary,
        ),
        AppText(
          label,
          variant: AppTextVariant.caption,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
