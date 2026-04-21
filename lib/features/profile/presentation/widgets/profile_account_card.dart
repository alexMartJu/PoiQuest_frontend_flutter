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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.manage_accounts_rounded, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  t.accountTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AccountOption(
              icon: Icons.person_outline,
              title: t.editProfile,
              subtitle: t.editProfileSubtitle,
              onTap: () => context.push('/profile/edit'),
            ),
            const Divider(height: 1),
            _AccountOption(
              icon: Icons.photo_camera_outlined,
              title: t.changeAvatar,
              subtitle: t.changeAvatarSubtitle,
              onTap: () => context.push('/profile/change-avatar'),
            ),
            const Divider(height: 1),
            _AccountOption(
              icon: Icons.lock_outline,
              title: t.changePassword,
              subtitle: t.changePasswordSubtitle,
              onTap: () => context.push('/profile/change-password'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
