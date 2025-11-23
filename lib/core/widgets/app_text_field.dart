import 'package:flutter/material.dart';

enum AppTextFieldVariant { text, email, password }

class AppTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final AppTextFieldVariant variant;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? maxLength;

  const AppTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.variant = AppTextFieldVariant.text,
    this.controller,
    this.validator,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.onChanged,
    this.maxLines,
    this.maxLength,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.variant == AppTextFieldVariant.password;
    final effectiveKeyboard = widget.keyboardType ??
        (widget.variant == AppTextFieldVariant.email
            ? TextInputType.emailAddress
            : TextInputType.text);

    return TextFormField(
      controller: widget.controller,
      obscureText: isPassword ? _obscurePassword : false,
      keyboardType: effectiveKeyboard,
      textCapitalization: widget.textCapitalization,
      enabled: widget.enabled,
      validator: widget.validator,
      maxLines: widget.maxLines ?? (isPassword ? 1 : 1),
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
      ),
    );
  }
}
