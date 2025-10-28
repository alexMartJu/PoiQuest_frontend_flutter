import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/preferences/presentation/providers/preferences_providers.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

// Página de preferencias del usuario.
// Permite cambiar el modo oscuro, idioma y notificaciones.
class PreferencesPage extends ConsumerWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(preferencesProvider);

    return prefsAsync.when(
      data: (prefs) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.preferences)),
          body: ListView(
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                value: prefs.darkmode,
                onChanged: (val) {
                  ref
                      .read(preferencesProvider.notifier)
                      .updatePreferences(prefs.copyWith(darkmode: val));
                },
              ),
              const Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context)!.language),
                trailing: DropdownButton<String>(
                  value: prefs.language,
                  items: [
                    DropdownMenuItem(
                      value: 'es',
                      child: Text(AppLocalizations.of(context)!.spanish),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(AppLocalizations.of(context)!.english),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(preferencesProvider.notifier)
                          .updatePreferences(prefs.copyWith(language: val));
                    }
                  },
                ),
              ),
              const Divider(),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.notifications),
                value: prefs.notifications,
                onChanged: (val) {
                  ref
                      .read(preferencesProvider.notifier)
                      .updatePreferences(prefs.copyWith(notifications: val));
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error al cargar preferencias: $e')),
      ),
    );
  }
}
