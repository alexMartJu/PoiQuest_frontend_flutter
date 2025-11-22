import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_text_field.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/utils/validators.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await ref.read(authProvider.notifier).signIn(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
      if (mounted) {
        final user = ref.read(authProvider).value;
        final t = AppLocalizations.of(context)!;
        if (user != null) {
          AppSnackBar.success(context, t.welcomeMessage(user.name));
        }
        context.go('/events');
      }
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        AppSnackBar.error(context, t.errorLogin(e.toString()));
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            AppTextField(
              controller: _emailCtrl,
              variant: AppTextFieldVariant.email,
              labelText: t.email,
              hintText: t.emailHint,
              prefixIcon: Icons.email_outlined,
              validator: Validators.email(context),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordCtrl,
              variant: AppTextFieldVariant.password,
              labelText: t.password,
              prefixIcon: Icons.lock_outline,
              validator: Validators.password(context),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  AppSnackBar.info(context, t.featureInDevelopment);
                },
                child: Text(t.forgotPassword),
              ),
            ),
            const SizedBox(height: 16),
            AppFilledButton(
              label: t.signIn,
              icon: Icons.login,
              onPressed: _submit,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
