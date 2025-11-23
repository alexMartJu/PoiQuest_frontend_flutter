import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/usecases/get_my_profile_usecases.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/usecases/update_my_profile_usecases.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/usecases/update_my_avatar_usecases.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/usecases/change_password_usecases.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';

/// Provider del data source remoto de perfil.
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource();
});

/// Provider del repositorio de perfil.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.watch(profileRemoteDataSourceProvider),
  );
});

/// Provider del caso de uso para obtener el perfil.
final getMyProfileUseCaseProvider = Provider<GetMyProfileUseCases>((ref) {
  return GetMyProfileUseCases(ref.watch(profileRepositoryProvider));
});

/// Provider del caso de uso para actualizar el perfil.
final updateMyProfileUseCaseProvider = Provider<UpdateMyProfileUseCases>((ref) {
  return UpdateMyProfileUseCases(ref.watch(profileRepositoryProvider));
});

/// Provider del caso de uso para actualizar el avatar.
final updateMyAvatarUseCaseProvider = Provider<UpdateMyAvatarUseCases>((ref) {
  return UpdateMyAvatarUseCases(ref.watch(profileRepositoryProvider));
});

/// Provider del caso de uso para cambiar la contraseña.
final changePasswordUseCaseProvider = Provider<ChangePasswordUseCases>((ref) {
  return ChangePasswordUseCases(ref.watch(profileRepositoryProvider));
});

/// Provider del estado del perfil del usuario autenticado.
///
/// Gestiona el estado global del perfil usando AsyncNotifier.
class ProfileNotifier extends AsyncNotifier<Profile?> {
  late final GetMyProfileUseCases _getMyProfileUseCase;
  late final UpdateMyProfileUseCases _updateMyProfileUseCase;
  late final UpdateMyAvatarUseCases _updateMyAvatarUseCase;
  late final ChangePasswordUseCases _changePasswordUseCase;

  @override
  Future<Profile?> build() async {
    _getMyProfileUseCase = ref.read(getMyProfileUseCaseProvider);
    _updateMyProfileUseCase = ref.read(updateMyProfileUseCaseProvider);
    _updateMyAvatarUseCase = ref.read(updateMyAvatarUseCaseProvider);
    _changePasswordUseCase = ref.read(changePasswordUseCaseProvider);
    return null; // El perfil se carga bajo demanda con loadProfile()
  }

  /// Carga el perfil del usuario autenticado.
  /// 
  /// Si el token ha caducado (401), cierra la sesión automáticamente.
  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _getMyProfileUseCase();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      // Si es un error 401 (no autorizado), el token ha caducado
      if (e is DioException && e.response?.statusCode == 401) {
        // Limpiar el perfil y cerrar sesión automáticamente
        state = const AsyncValue.data(null);
        ref.read(authProvider.notifier).signOut();
        // No hacer rethrow para evitar mostrar el error al usuario
        return;
      }
      
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Actualiza el perfil del usuario autenticado.
  Future<void> updateProfile({
    String? name,
    String? lastname,
    String? bio,
  }) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _updateMyProfileUseCase(
        name: name,
        lastname: lastname,
        bio: bio,
      );
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Actualiza el avatar del usuario autenticado.
  Future<void> updateAvatar(String avatarUrl) async {
    state = const AsyncValue.loading();
    try {
      final profile = await _updateMyAvatarUseCase(avatarUrl);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Cambia la contraseña del usuario autenticado.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _changePasswordUseCase(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  /// Limpia el estado del perfil.
  void clear() {
    state = const AsyncValue.data(null);
  }
}

/// Provider del notifier de perfil.
final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);
