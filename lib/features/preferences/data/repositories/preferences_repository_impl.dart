import 'package:poiquest_frontend_flutter/features/preferences/data/datasources/preferences_local_data_source.dart';
import 'package:poiquest_frontend_flutter/features/preferences/domain/entities/preferences.dart';
import 'package:poiquest_frontend_flutter/features/preferences/domain/repositories/preferences_repository.dart';

// Implementación concreta del repositorio de preferencias.
// Usa SharedPreferences para persistir los datos localmente.
class PreferencesRepositoryImpl implements PreferencesRepository {
  final PreferencesLocalDataSource localDatasource;

  PreferencesRepositoryImpl(this.localDatasource);

  @override
  Future<Preferences> getPreferences() async {
    final prefs = await localDatasource.fetchPreferences();
    final dark = prefs.getBool(Preferences.darkModeConst) ?? false;
    final lang = prefs.getString(Preferences.languageConst) ?? 'es';
    final notif = prefs.getBool(Preferences.notificationsConst) ?? true;

    return Preferences(darkmode: dark, language: lang, notifications: notif);
  }

  @override
  Future<void> setPreferences(Preferences preferences) async {
    await localDatasource.savePreferences(preferences);
  }
}
