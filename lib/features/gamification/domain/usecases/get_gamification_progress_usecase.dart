import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/repositories/gamification_repository.dart';

/// Caso de uso que encapsula la obtención del progreso de gamificación
/// del usuario autenticado.
///
/// Mantener esta capa facilita añadir validaciones, caching o
/// lógica de negocio adicional en el futuro sin modificar el Notifier.
class GetGamificationProgress {
  final GamificationRepository repository;

  GetGamificationProgress(this.repository);

  Future<GamificationProgress> call() {
    return repository.getMyProgress();
  }
}
