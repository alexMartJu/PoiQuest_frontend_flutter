import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/preferences/data/datasources/preferences_local_data_source.dart';
import 'package:poiquest_frontend_flutter/features/preferences/data/repositories/preferences_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/preferences/domain/entities/preferences.dart';
import 'package:poiquest_frontend_flutter/features/preferences/domain/usecases/preferences_usecases.dart';

// Notifier que gestiona el estado de las preferencias.
class PreferencesNotifier extends AsyncNotifier<Preferences> {
  late final PreferencesUseCases _usecases;

  @override
  Future<Preferences> build() async {
    _usecases = PreferencesUseCases(
      PreferencesRepositoryImpl(PreferencesLocalDataSource()),
    );
    return _usecases.getPreferences();
  }

  Future<void> updatePreferences(Preferences newPrefs) async {
    try {
      state = const AsyncLoading();
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
