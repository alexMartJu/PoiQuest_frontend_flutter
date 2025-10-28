import 'package:poiquest_frontend_flutter/features/preferences/domain/entities/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fuente de datos local que maneja la lectura y escritura de preferencias utilizando SharedPreferences.
class PreferencesLocalDataSource {
  Future<SharedPreferences> fetchPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> savePreferences(Preferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Preferences.darkModeConst, preferences.darkmode);
    await prefs.setString(Preferences.languageConst, preferences.language);
    await prefs.setBool(Preferences.notificationsConst, preferences.notifications);
  }
}
