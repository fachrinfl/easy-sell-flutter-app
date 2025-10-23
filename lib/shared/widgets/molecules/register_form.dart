import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../atoms/app_button.dart';
import '../atoms/app_password_field.dart';
import '../atoms/app_switch.dart';
import '../atoms/app_text.dart';
import '../atoms/app_text_field.dart';

class RegisterForm extends StatefulWidget {
  final Function(
    String name,
    String email,
    String password,
    String confirmPassword,
  )?
  onSubmit;
  final Function()? onLogin;
  final bool isLoading;
  final String? errorMessage;
  final bool agreeToTerms;
  final Function(bool)? onAgreeToTermsChanged;

  const RegisterForm({
    super.key,
    this.onSubmit,
    this.onLogin,
    this.isLoading = false,
    this.errorMessage,
    this.agreeToTerms = false,
    this.onAgreeToTermsChanged,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outlined,
            validator: _validateName,
          ),
          const SizedBox(height: AppSpacing.md),
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
            hint: 'Create a password',
            validator: _validatePassword,
          ),
          const SizedBox(height: AppSpacing.md),
          AppPasswordField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Confirm your password',
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSwitch(
            label: 'I agree to the Terms of Service and Privacy Policy',
            value: widget.agreeToTerms,
            onChanged: widget.onAgreeToTermsChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            'Create Account',
            variant: widget.agreeToTerms
                ? AppButtonVariant.primary
                : AppButtonVariant.secondary,
            onPressed: (widget.isLoading || !widget.agreeToTerms)
                ? null
                : _handleSubmit,
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
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _confirmPasswordController.text,
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
