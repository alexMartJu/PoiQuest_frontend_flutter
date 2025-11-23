import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_profile_request.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_avatar_request.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/change_password_request.dart';

/// Repositorio abstracto para operaciones de perfil.
abstract class ProfileRepository {
  /// Obtiene el perfil del usuario autenticado.
  Future<Profile> getMyProfile();

  /// Actualiza el perfil del usuario autenticado.
  Future<Profile> updateMyProfile(UpdateProfileRequest request);

  /// Actualiza el avatar del usuario autenticado.
  Future<Profile> updateMyAvatar(UpdateAvatarRequest request);

  /// Cambia la contraseña del usuario autenticado.
  Future<void> changePassword(ChangePasswordRequest request);
}
