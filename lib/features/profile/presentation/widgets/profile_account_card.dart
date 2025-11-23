import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Card con las opciones de configuración de la cuenta del usuario.
///
/// Incluye: Editar perfil, Cambiar avatar, Cambiar contraseña.
class ProfileAccountCard extends StatelessWidget {
  const ProfileAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(t.editProfile),
            subtitle: Text(t.editProfileSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/edit'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(t.changeAvatar),
            subtitle: Text(t.changeAvatarSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/change-avatar'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(t.changePassword),
            subtitle: Text(t.changePasswordSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/change-password'),
          ),
        ],
      ),
    );
  }
}
