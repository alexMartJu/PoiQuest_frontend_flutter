import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_profile_request.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_avatar_request.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/change_password_request.dart';

/// Implementación del repositorio de perfil.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Profile> getMyProfile() async {
    final model = await _remoteDataSource.getMyProfile();
    return model.toEntity();
  }

  @override
  Future<Profile> updateMyProfile(UpdateProfileRequest request) async {
    final model = await _remoteDataSource.updateMyProfile(request);
    return model.toEntity();
  }

  @override
  Future<Profile> updateMyAvatar(UpdateAvatarRequest request) async {
    final model = await _remoteDataSource.updateMyAvatar(request);
    return model.toEntity();
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    await _remoteDataSource.changePassword(request);
  }
}
