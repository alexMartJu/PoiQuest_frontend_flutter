import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/providers/profile_provider.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_text_field.dart';
import 'package:poiquest_frontend_flutter/core/utils/validators.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Página para cambiar el avatar del perfil.
class ProfileChangeAvatarPage extends ConsumerStatefulWidget {
  const ProfileChangeAvatarPage({super.key});

  @override
  ConsumerState<ProfileChangeAvatarPage> createState() => _ProfileChangeAvatarPageState();
}

class _ProfileChangeAvatarPageState extends ConsumerState<ProfileChangeAvatarPage> {
  final _formKey = GlobalKey<FormState>();
  final _avatarUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Cargar el avatar actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(profileProvider);
      profileState.whenData((profile) {
        if (profile?.avatarUrl != null) {
          _avatarUrlController.text = profile!.avatarUrl!;
        }
      });
    });
  }

  @override
  void dispose() {
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(profileProvider.notifier)
          .updateAvatar(_avatarUrlController.text.trim());

      if (mounted) {
        final t = AppLocalizations.of(context)!;
        AppSnackBar.success(context, t.avatarUpdatedSuccess);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        AppSnackBar.error(context, t.avatarUpdateError(e.toString()));
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.changeAvatar),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Preview del avatar
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.primary,
                backgroundImage: _avatarUrlController.text.isNotEmpty
                    ? NetworkImage(_avatarUrlController.text)
                    : null,
                child: _avatarUrlController.text.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: colorScheme.onPrimary,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Campo URL
            AppTextField(
              controller: _avatarUrlController,
              labelText: t.avatarUrl,
              hintText: t.avatarUrlHint,
              prefixIcon: Icons.link,
              keyboardType: TextInputType.url,
              onChanged: (_) => setState(() {}), // Actualizar preview
              validator: Validators.url(context, maxLength: 255),
              maxLength: 255,
            ),
            const SizedBox(height: 8),
            Text(
              t.avatarUrlHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            AppFilledButton(
              label: t.updateAvatar,
              onPressed: _isLoading ? null : _handleSubmit,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
