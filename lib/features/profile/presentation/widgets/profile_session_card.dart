import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Card con las opciones de gestión de sesiones del usuario.
///
/// Incluye: Cerrar sesión en este dispositivo, Cerrar sesión en todos los dispositivos.
class ProfileSessionCard extends StatelessWidget {
  /// Callback para cerrar sesión en el dispositivo actual.
  final VoidCallback onLogout;

  /// Callback para cerrar sesión en todos los dispositivos.
  final VoidCallback onLogoutAll;

  const ProfileSessionCard({
    super.key,
    required this.onLogout,
    required this.onLogoutAll,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(t.logout),
            subtitle: Text(t.logoutSubtitle),
            onTap: onLogout,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: colorScheme.error,
            ),
            title: Text(
              t.logoutAllDevices,
              style: TextStyle(color: colorScheme.error),
            ),
            subtitle: Text(t.logoutAllDevicesSubtitle),
            onTap: onLogoutAll,
          ),
        ],
      ),
    );
  }
}
