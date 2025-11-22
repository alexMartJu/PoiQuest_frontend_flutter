import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para cerrar sesión en el dispositivo actual.
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// Ejecuta el logout del dispositivo actual.
  Future<void> call() async {
    await _repository.logout();
  }
}
