import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/providers/profile_provider.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_text_field.dart';
import 'package:poiquest_frontend_flutter/core/utils/validators.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_dialog.dart';

/// Página para cambiar la contraseña.
class ProfileChangePasswordPage extends ConsumerStatefulWidget {
  const ProfileChangePasswordPage({super.key});

  @override
  ConsumerState<ProfileChangePasswordPage> createState() => _ProfileChangePasswordPageState();
}

class _ProfileChangePasswordPageState extends ConsumerState<ProfileChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(profileProvider.notifier).changePassword(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
          );

      if (mounted) {
        final t = AppLocalizations.of(context)!;
        // Mostrar diálogo de éxito
        await AppDialog.showAlert(
          context,
          title: t.passwordUpdatedTitle,
          content: t.passwordUpdatedContent,
        );

        // Cerrar todas las sesiones
        await ref.read(authProvider.notifier).signOutAll();
        ref.read(profileProvider.notifier).clear();

        if (mounted) {
          context.go('/events');
        }
      }
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        String message = t.passwordChangeError;

        // Manejo específico para errores HTTP/Dio que provienen del backend
        if (e is DioException) {
          final data = e.response?.data;
          if (data is Map<String, dynamic>) {
            final code = data['code'] as String?;
            final serverMessage = data['message'] as String?;

            if (code == 'UNAUTHORIZED') {
              // Caso: contraseña actual incorrecta (regla aplicada en AppService)
              message = t.passwordIncorrect;
            } else if (serverMessage != null && serverMessage.isNotEmpty) {
              message = serverMessage;
            } else if (e.message != null && e.message!.isNotEmpty) {
              message = e.message!;
            }
          } else if (e.message != null) {
            message = e.message!;
          }
        } else {
          message = e.toString();
        }

        AppSnackBar.error(context, message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.changePassword),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Contraseña actual
            AppTextField(
              controller: _oldPasswordController,
              labelText: t.oldPassword,
              prefixIcon: Icons.lock_outline,
              variant: AppTextFieldVariant.password,
              validator: Validators.required(context, fieldName: t.oldPassword),
            ),
            const SizedBox(height: 16),

            // Nueva contraseña
            AppTextField(
              controller: _newPasswordController,
              labelText: t.newPassword,
              prefixIcon: Icons.lock_outline,
              variant: AppTextFieldVariant.password,
              validator: Validators.strongPassword(context),
            ),
            const SizedBox(height: 16),

            // Confirmar nueva contraseña
            AppTextField(
              controller: _confirmPasswordController,
              labelText: t.confirmNewPassword,
              prefixIcon: Icons.lock_outline,
              variant: AppTextFieldVariant.password,
              validator: (value) => Validators.confirmPassword(context, _newPasswordController.text)(value),
            ),
            const SizedBox(height: 8),

            // Información de requisitos
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.passwordRequirementsTitle,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(t.passwordRequirementMinLength),
                    Text(t.passwordRequirementUppercase),
                    Text(t.passwordRequirementLowercase),
                    Text(t.passwordRequirementNumber),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            AppFilledButton(
              label: t.changePassword,
              onPressed: _isLoading ? null : _handleSubmit,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
