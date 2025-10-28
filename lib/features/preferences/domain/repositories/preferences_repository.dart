import 'package:poiquest_frontend_flutter/features/preferences/domain/entities/preferences.dart';

// Contrato del repositorio de preferencias.
// Define qué operaciones puede realizar la capa de dominio.
abstract class PreferencesRepository {
  Future<Preferences> getPreferences();
  Future<void> setPreferences(Preferences preferences);
}
