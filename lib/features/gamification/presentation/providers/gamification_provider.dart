import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/gamification/data/datasources/gamification_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/usecases/get_gamification_progress_usecase.dart';

/// Providers y Notifiers de la feature `gamification`.
///
/// Responsabilidad: exponer las abstracciones necesarias para la capa
/// de presentación (UI) y orquestar la comunicación con la capa de dominio
/// y datos.
///
/// Flujo resumido: `ProfilePage` (UI) -> `gamificationProgressProvider` (Notifier)
/// -> `GetGamificationProgress` (UseCase) -> `GamificationRepository`
/// -> `GamificationRemoteDataSource` -> HTTP.

// Provider que expone la instancia del data source HTTP (Dio).
// Se utiliza `const` cuando es posible para optimizar y favorecer la
// inmutabilidad; permite inyectar otra implementación en tests si es necesario.
final gamificationRemoteDataSourceProvider = Provider<GamificationRemoteDataSource>((ref) {
  return const GamificationRemoteDataSource();
});

// Provider del repositorio
final gamificationRepositoryProvider = Provider<GamificationRepository>(
  (ref) => GamificationRepositoryImpl(
    ref.watch(gamificationRemoteDataSourceProvider),
  ),
);

// Usecase provider
final getGamificationProgressUseCaseProvider = Provider<GetGamificationProgress>((ref) {
  final repo = ref.watch(gamificationRepositoryProvider);
  return GetGamificationProgress(repo);
});

// Progress provider
final gamificationProgressProvider =
    AsyncNotifierProvider<GamificationNotifier, GamificationProgress?>(
  GamificationNotifier.new,
);

/// Notifier que gestiona el estado del progreso de gamificación del usuario.
///
/// El estado inicial es `null` (no cargado). Llama a [loadProgress] para
/// obtener los datos del servidor. [clear] reinicia el estado, útil al
/// cerrar sesión.
class GamificationNotifier extends AsyncNotifier<GamificationProgress?> {
  @override
  Future<GamificationProgress?> build() async {
    return null;
  }

  Future<void> loadProgress() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final usecase = ref.read(getGamificationProgressUseCaseProvider);
      return await usecase();
    });
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}
