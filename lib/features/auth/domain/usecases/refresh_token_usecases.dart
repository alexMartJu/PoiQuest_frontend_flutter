import 'package:poiquest_frontend_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para refrescar el access token.
class RefreshTokenUseCase {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  /// Ejecuta el refresh del access token.
  Future<AuthTokens> call() async {
    return await _repository.refreshAccessToken();
  }
}
