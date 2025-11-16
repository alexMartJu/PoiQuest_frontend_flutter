import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poiquest_frontend_flutter/features/preferences/data/datasources/preferences_local_data_source.dart';
import 'package:poiquest_frontend_flutter/features/preferences/data/repositories/preferences_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/preferences/domain/entities/preferences.dart';
import 'package:poiquest_frontend_flutter/features/preferences/domain/usecases/preferences_usecases.dart';

// Cache para evitar reinicializar locales ya cargadas
final Set<String> _initializedLocales = <String>{};

Future<void> _ensureLocaleInitialized(String locale) async {
  if (locale.isEmpty) return;
  if (_initializedLocales.contains(locale)) return;
  await initializeDateFormatting(locale);
  _initializedLocales.add(locale);
}

// Notifier que gestiona el estado de las preferencias.
class PreferencesNotifier extends AsyncNotifier<Preferences> {
  late final PreferencesUseCases _usecases;

  @override
  Future<Preferences> build() async {
    _usecases = PreferencesUseCases(
      PreferencesRepositoryImpl(PreferencesLocalDataSource()),
    );
    final prefs = await _usecases.getPreferences();
    
    // Inicializar símbolos de fecha para la locale guardada
    await _ensureLocaleInitialized(prefs.language);
    
    return prefs;
  }

  Future<void> updatePreferences(Preferences newPrefs) async {
    try {
      state = const AsyncLoading();
      
      // Inicializar símbolos de fecha para la nueva locale antes de persistir
      await _ensureLocaleInitialized(newPrefs.language);
      
      await _usecases.setPreferences(newPrefs);
      state = AsyncValue.data(newPrefs);
      state = await AsyncValue.guard(_usecases.getPreferences);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// Provider global para acceder a las preferencias desde cualquier parte.
final preferencesProvider =
    AsyncNotifierProvider<PreferencesNotifier, Preferences>(
        PreferencesNotifier.new);
