import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/atoms/app_text_button.dart';
import '../../../shared/widgets/molecules/auth_header.dart';
import '../../../shared/widgets/molecules/auth_footer.dart';
import '../../../shared/widgets/molecules/login_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthHeader(
                title: 'Welcome Back',
                subtitle: 'Sign in to your account',
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
                child: LoginForm(
                  key: const ValueKey('login_form'),
                  onSubmit: _handleLogin,
                  onForgotPassword: () => context.go('/forgot-password'),
                  onRegister: () => context.go('/register'),
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                ),
              ),
              AuthFooter(
                primaryText: 'New to EasySell POS?',
                actionText: 'Create Account',
                onAction: () => context.go('/register'),
                links: [
                  AppTextButton(
                    'Forgot your password?',
                    onPressed: () => context.go('/forgot-password'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(String email, String password) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
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
}
