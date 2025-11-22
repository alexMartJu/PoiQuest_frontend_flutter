import 'package:poiquest_frontend_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para el login de usuario.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Ejecuta el login con email y contraseña.
  Future<AuthTokens> call({
    required String email,
    required String password,
  }) async {
    return await _repository.login(email: email, password: password);
  }
}
