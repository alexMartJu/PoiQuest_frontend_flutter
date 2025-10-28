import 'package:poiquest_frontend_flutter/features/preferences/domain/entities/preferences.dart';
import 'package:poiquest_frontend_flutter/features/preferences/domain/repositories/preferences_repository.dart';

// Casos de uso: definen las acciones de negocio que se pueden realizar con las preferencias.
class PreferencesUseCases {
  final Future<Preferences> Function() getPreferences;
  final Future<void> Function(Preferences preferences) setPreferences;

  PreferencesUseCases(PreferencesRepository repo)
      : getPreferences = repo.getPreferences,
        setPreferences = repo.setPreferences;
}
