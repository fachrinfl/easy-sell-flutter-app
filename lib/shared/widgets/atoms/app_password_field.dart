import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;

  final String? helperText;
  final String? errorText;
  final String? initialValue;
  final TextEditingController? controller;

  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  final AppTextFieldVariant variant;

  final AppTextFieldSize size;

  final bool showStrengthIndicator;

  final String? Function(String?)? strengthValidator;

  const AppPasswordField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.variant = AppTextFieldVariant.outlined,
    this.size = AppTextFieldSize.medium,
    this.showStrengthIndicator = false,
    this.strengthValidator,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = true;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _password = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: widget.label,
          hint: widget.hint ?? 'Enter your password',
          helperText: widget.helperText,
          errorText: widget.errorText,
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: widget.textInputAction,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          obscureText: _obscureText,
          onChanged: _onPasswordChanged,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: _validatePassword,
          variant: widget.variant,
          size: widget.size,
          keyboardType: TextInputType.visiblePassword,
          suffix: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        if (widget.showStrengthIndicator && _password.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildPasswordStrengthIndicator(),
        ],
      ],
    );
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = value;
    });
    widget.onChanged?.call(value);
  }

  String? _validatePassword(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (widget.strengthValidator != null) {
      return widget.strengthValidator!(value);
    }

    return null;
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = _calculatePasswordStrength(_password);
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 4,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                minHeight: 4,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              strengthText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: strengthColor,
              ),
            ),
          ],
        ),
        if (_password.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildPasswordRequirements(),
        ],
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    final requirements = [
      _PasswordRequirement(
        text: 'At least 8 characters',
        met: _password.length >= 8,
      ),
      _PasswordRequirement(
        text: 'Contains uppercase letter',
        met: _password.contains(RegExp(r'[A-Z]')),
      ),
      _PasswordRequirement(
        text: 'Contains lowercase letter',
        met: _password.contains(RegExp(r'[a-z]')),
      ),
      _PasswordRequirement(
        text: 'Contains number',
        met: _password.contains(RegExp(r'[0-9]')),
      ),
      _PasswordRequirement(
        text: 'Contains special character',
        met: _password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) => _buildRequirementItem(req)).toList(),
    );
  }

  Widget _buildRequirementItem(_PasswordRequirement requirement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            requirement.met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: requirement.met ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            requirement.text,
            style: TextStyle(
              fontSize: 12,
              color: requirement.met ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength;
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return 'Very Weak';
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}

class _PasswordRequirement {
  final String text;
  final bool met;

  _PasswordRequirement({required this.text, required this.met});
}
