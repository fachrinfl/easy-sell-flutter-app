import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_icon_button.dart';
import '../atoms/app_text.dart';
import '../atoms/app_text_field.dart';
import '../molecules/app_app_bar.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _businessNameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(businessNameProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessNameAsync = ref.watch(businessNameProvider);

    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: AppText(
            'Settings',
            variant: AppTextVariant.titleLarge,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                : AppIconButton(
                    Icons.save,
                    onPressed: _isSaving ? null : () => _saveBusinessName(),
                    tooltip: 'Save Settings',
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
              _buildBusinessSettings(businessNameAsync),
              const SizedBox(height: AppSpacing.xl),
              _buildAboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessSettings(AsyncValue<String?> businessNameAsync) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Business Settings', variant: AppTextVariant.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            businessNameAsync.when(
              data: (businessName) {
                if (_businessNameController.text != (businessName ?? '')) {
                  _businessNameController.text = businessName ?? '';
                }
                return Stack(
                  children: [
                    AppTextField(
                      controller: _businessNameController,
                      label: 'Business Name',
                      hint: 'Enter your business name',
                      enabled: !_isSaving,
                    ),
                    if (_isSaving)
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => AppText(
                'Error loading business name: $error',
                variant: AppTextVariant.bodySmall,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('About', variant: AppTextVariant.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            AppText('EasySell POS v1.0.0', variant: AppTextVariant.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              'A simple point-of-sale solution for small businesses',
              variant: AppTextVariant.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                'Logout',
                variant: AppButtonVariant.danger,
                onPressed: () => _showLogoutDialog(),
                icon: Icons.logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText('Logout'),
        content: const AppText(
          'Are you sure you want to logout? You will need to sign in again to access your account.',
        ),
        actions: [
          AppButton(
            'Cancel',
            variant: AppButtonVariant.text,
            onPressed: () => Navigator.pop(context),
          ),
          AppButton(
            'Logout',
            variant: AppButtonVariant.danger,
            onPressed: () async {
              Navigator.pop(context);
              await _handleLogout();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();

      if (mounted) {
        _showSnackBar('Logged out successfully');
        context.go('/welcome');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error logging out: ${e.toString()}');
      }
    }
  }

  Future<void> _saveBusinessName() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final businessName = _businessNameController.text.trim();

      if (businessName.isEmpty) {
        _showSnackBar('Business name cannot be empty');
        return;
      }

      await ref
          .read(businessNameProvider.notifier)
          .updateBusinessName(businessName);
      _showSnackBar('Business name saved successfully');
    } catch (e) {
      _showSnackBar('Error saving business name: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
