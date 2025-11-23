import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/providers/profile_provider.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_text_field.dart';
import 'package:poiquest_frontend_flutter/core/utils/validators.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Página para editar la información del perfil.
class ProfileEditProfilePage extends ConsumerStatefulWidget {
  const ProfileEditProfilePage({super.key});

  @override
  ConsumerState<ProfileEditProfilePage> createState() => _ProfileEditProfilePageState();
}

class _ProfileEditProfilePageState extends ConsumerState<ProfileEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Cargar los datos del perfil actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(profileProvider);
      profileState.whenData((profile) {
        if (profile != null) {
          _nameController.text = profile.name ?? '';
          _lastnameController.text = profile.lastname ?? '';
          _bioController.text = profile.bio ?? '';
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(profileProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
            lastname: _lastnameController.text.trim(),
            bio: _bioController.text.trim(),
          );

      if (mounted) {
        final t = AppLocalizations.of(context)!;
        AppSnackBar.success(context, t.profileUpdatedSuccess);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        AppSnackBar.error(context, t.profileUpdateError(e.toString()));
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
        title: Text(t.editProfile),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            AppTextField(
              controller: _nameController,
              labelText: t.name,
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: Validators.name(context),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _lastnameController,
              labelText: t.lastname,
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: Validators.lastname(context),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _bioController,
              labelText: t.bio,
              prefixIcon: Icons.description_outlined,
              hintText: t.bioHint,
              maxLines: 4,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              validator: Validators.maxLength(context, 500, fieldName: t.bio),
            ),
            const SizedBox(height: 24),
            AppFilledButton(
              label: t.saveChanges,
              onPressed: _isLoading ? null : _handleSubmit,
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
