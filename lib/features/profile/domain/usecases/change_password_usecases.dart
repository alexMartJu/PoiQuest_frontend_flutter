import 'package:poiquest_frontend_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/change_password_request.dart';

/// Caso de uso para cambiar la contraseña del usuario autenticado.
class ChangePasswordUseCases {
  final ProfileRepository repository;

  ChangePasswordUseCases(this.repository);

  Future<void> call({
    required String oldPassword,
    required String newPassword,
  }) async {
    final request = ChangePasswordRequest(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    return await repository.changePassword(request);
  }
}
