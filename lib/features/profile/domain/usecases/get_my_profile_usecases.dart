import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/repositories/profile_repository.dart';

/// Caso de uso para obtener el perfil del usuario autenticado.
class GetMyProfileUseCases {
  final ProfileRepository repository;

  GetMyProfileUseCases(this.repository);

  Future<Profile> call() async {
    return await repository.getMyProfile();
  }
}
