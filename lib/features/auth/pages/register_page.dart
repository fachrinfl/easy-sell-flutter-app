import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/atoms/app_text.dart';
import '../../../shared/widgets/atoms/app_text_button.dart';
import '../../../shared/widgets/molecules/auth_footer.dart';
import '../../../shared/widgets/molecules/auth_header.dart';
import '../../../shared/widgets/molecules/register_form.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthHeader(
                title: 'Create Account',
                subtitle: 'Join thousands of businesses using EasySell POS',
                showLogo: true,
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/login');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: RegisterForm(
                  onSubmit: _handleRegister,
                  onLogin: () => context.go('/login'),
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                  agreeToTerms: _agreeToTerms,
                  onAgreeToTermsChanged: (value) {
                    setState(() {
                      _agreeToTerms = value;
                    });
                  },
                ),
              ),
              AuthFooter(
                primaryText: 'Already have an account?',
                actionText: 'Sign In',
                onAction: () => context.go('/login'),
                links: [
                  AppTextButton(
                    'Terms of Service',
                    onPressed: () => _showTermsDialog(),
                  ),
                  AppTextButton(
                    'Privacy Policy',
                    onPressed: () => _showPrivacyDialog(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (!_agreeToTerms) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Please agree to the Terms of Service and Privacy Policy';
        });
      }
      return;
    }

    if (password != confirmPassword) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Passwords do not match';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final authService = ref.read(authServiceProvider);

      User? user;
      try {
        final credential = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        user = credential.user;
      } catch (e) {
        if (e.toString().contains('PigeonUserDetails')) {
          await Future.delayed(const Duration(seconds: 1));
          user = authService.currentUser;
          if (user != null) {
          } else {
            throw Exception('User creation failed: $e');
          }
        } else {
          throw e;
        }
      }

      if (user != null) {
        try {
          await authService.updateUserProfile(displayName: name);
        } catch (e) {
          if (e.toString().contains('PigeonUserInfo')) {
          } else {}
        }

        final businessName = '$name Store';
        try {
          await authService.createUserDocument(
            uid: user.uid,
            email: email,
            displayName: name,
            businessName: businessName,
          );
        } catch (e) {}
      } else {
        throw Exception('User creation failed - no user returned');
      }

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Terms of Service',
          variant: AppTextVariant.titleLarge,
          color: AppColors.textPrimary,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Last Updated: December 2024',
                variant: AppTextVariant.caption,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '1. Acceptance of Terms',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'By using EasySell POS, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '2. Use of Service',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'EasySell POS is designed for legitimate business purposes. You may not use the service for any illegal or unauthorized activities.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '3. Data and Privacy',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'Your business data is stored securely and is only accessible to you. We do not share your data with third parties without your explicit consent.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '4. Service Availability',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'We strive to maintain high service availability, but we do not guarantee uninterrupted access to the service.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
        actions: [
          AppTextButton('Close', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Privacy Policy',
          variant: AppTextVariant.titleLarge,
          color: AppColors.textPrimary,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Last Updated: December 2024',
                variant: AppTextVariant.caption,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '1. Information We Collect',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'We collect information you provide directly to us, such as when you create an account, including your name, email address, and business information.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '2. How We Use Your Information',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'We use your information to provide, maintain, and improve our services, process transactions, and communicate with you about your account.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '3. Data Security',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '4. Data Sharing',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as required by law.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText(
                '5. Your Rights',
                variant: AppTextVariant.titleSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                'You have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting us.',
                variant: AppTextVariant.bodyMedium,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
        actions: [
          AppTextButton('Close', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
