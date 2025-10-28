import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/preferences/presentation/providers/preferences_providers.dart';

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
          appBar: AppBar(title: const Text('Preferencias')),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Modo oscuro'),
                value: prefs.darkmode,
                onChanged: (val) {
                  ref
                      .read(preferencesProvider.notifier)
                      .updatePreferences(prefs.copyWith(darkmode: val));
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Idioma'),
                trailing: DropdownButton<String>(
                  value: prefs.language,
                  items: const [
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'en', child: Text('Inglés')),
                    DropdownMenuItem(value: 'fr', child: Text('Francés')),
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
                title: const Text('Notificaciones'),
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
