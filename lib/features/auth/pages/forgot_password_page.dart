import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/molecules/auth_header.dart';
import '../../../shared/widgets/molecules/auth_footer.dart';
import '../../../shared/widgets/molecules/forgot_password_form.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthHeader(
                title: 'Reset Password',
                subtitle: 'Enter your email to receive a reset link',
                showLogo: true,
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: ForgotPasswordForm(
                  onSubmit: _handleForgotPassword,
                  onBackToLogin: () => context.go('/login'),
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                  successMessage: _successMessage,
                ),
              ),
              AuthFooter(
                primaryText: 'Remember your password?',
                actionText: 'Sign In',
                onAction: () => context.go('/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleForgotPassword(String email) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendPasswordResetEmail(email);
      
      setState(() {
        _successMessage = 'Password reset link sent to $email';
      });
      
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          context.go('/login');
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
