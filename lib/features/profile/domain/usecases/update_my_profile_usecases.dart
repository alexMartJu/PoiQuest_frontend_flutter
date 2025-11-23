import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_profile_request.dart';

/// Caso de uso para actualizar el perfil del usuario autenticado.
class UpdateMyProfileUseCases {
  final ProfileRepository repository;

  UpdateMyProfileUseCases(this.repository);

  Future<Profile> call({
    required String? name,
    required String? lastname,
    required String? bio,
  }) async {
    final request = UpdateProfileRequest(
      name: name,
      lastname: lastname,
      bio: bio,
    );
    return await repository.updateMyProfile(request);
  }
}
