import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_avatar_request.dart';

/// Caso de uso para actualizar el avatar del usuario autenticado.
class UpdateMyAvatarUseCases {
  final ProfileRepository repository;

  UpdateMyAvatarUseCases(this.repository);

  Future<Profile> call(String avatarUrl) async {
    final request = UpdateAvatarRequest(avatarUrl: avatarUrl);
    return await repository.updateMyAvatar(request);
  }
}
