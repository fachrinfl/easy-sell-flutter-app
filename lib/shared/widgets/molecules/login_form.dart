import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_button.dart';
import '../atoms/app_password_field.dart';
import '../atoms/app_text.dart';
import '../atoms/app_text_button.dart';
import '../atoms/app_text_field.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password)? onSubmit;
  final Function()? onForgotPassword;
  final Function()? onRegister;
  final bool isLoading;
  final String? errorMessage;

  const LoginForm({
    super.key,
    this.onSubmit,
    this.onForgotPassword,
    this.onRegister,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.error),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: AppColors.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppText(
                      widget.errorMessage!,
                      variant: AppTextVariant.bodySmall,
                      color: AppColors.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
          ),
          const SizedBox(height: AppSpacing.md),
          AppPasswordField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            validator: _validatePassword,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppTextButton(
                'Forgot Password?',
                onPressed: widget.onForgotPassword,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            'Sign In',
            variant: AppButtonVariant.primary,
            onPressed: widget.isLoading ? null : _handleSubmit,
            loading: widget.isLoading,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit?.call(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
