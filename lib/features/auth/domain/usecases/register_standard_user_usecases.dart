import 'package:poiquest_frontend_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para el registro de usuario estándar.
class RegisterStandardUserUseCase {
  final AuthRepository _repository;

  RegisterStandardUserUseCase(this._repository);

  /// Ejecuta el registro de un nuevo usuario.
  Future<AuthTokens> call({
    required String name,
    required String lastname,
    required String email,
    required String password,
    String? avatarUrl,
    String? bio,
  }) async {
    return await _repository.registerStandardUser(
      name: name,
      lastname: lastname,
      email: email,
      password: password,
      avatarUrl: avatarUrl,
      bio: bio,
    );
  }
}
