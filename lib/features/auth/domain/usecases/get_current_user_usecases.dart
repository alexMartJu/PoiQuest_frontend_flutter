import 'package:poiquest_frontend_flutter/features/auth/domain/entities/user.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para obtener el usuario actual.
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Obtiene los datos del usuario autenticado actual.
  Future<User> call() async {
    return await _repository.getCurrentUser();
  }
}
