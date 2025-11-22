import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para cerrar todas las sesiones del usuario.
class LogoutAllUseCase {
  final AuthRepository _repository;

  LogoutAllUseCase(this._repository);

  /// Ejecuta el logout de todos los dispositivos.
  Future<void> call() async {
    await _repository.logoutAll();
  }
}
