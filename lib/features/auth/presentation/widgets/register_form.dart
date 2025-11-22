import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_text_field.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/utils/validators.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _lastnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastnameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await ref.read(authProvider.notifier).signUp(
            name: _nameCtrl.text.trim(),
            lastname: _lastnameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
      if (mounted) context.go('/events');
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        AppSnackBar.error(context, t.errorRegister(e.toString()));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            AppTextField(
              controller: _nameCtrl,
              labelText: t.name,
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: Validators.name(context),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _lastnameCtrl,
              labelText: t.lastname,
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: Validators.lastname(context),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _emailCtrl,
              variant: AppTextFieldVariant.email,
              labelText: t.email,
              hintText: t.emailHint,
              prefixIcon: Icons.email_outlined,
              validator: Validators.emailWithMaxLength(context),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordCtrl,
              variant: AppTextFieldVariant.password,
              labelText: t.password,
              prefixIcon: Icons.lock_outline,
              validator: Validators.strongPassword(context),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _confirmPasswordCtrl,
              variant: AppTextFieldVariant.password,
              labelText: t.confirmPassword,
              prefixIcon: Icons.lock_outline,
              validator: Validators.confirmPassword(context, _passwordCtrl.text),
            ),
            const SizedBox(height: 20),
            AppFilledButton(
              label: t.register,
              icon: Icons.person_add,
              onPressed: _submit,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
