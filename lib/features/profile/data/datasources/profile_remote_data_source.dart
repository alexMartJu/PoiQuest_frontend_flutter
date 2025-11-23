import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/profile_model.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_profile_request.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/update_avatar_request.dart';
import 'package:poiquest_frontend_flutter/features/profile/data/models/change_password_request.dart';

/// Fuente de datos remota para perfil.
///
/// Maneja todas las peticiones HTTP relacionadas con el perfil usando Dio.
class ProfileRemoteDataSource {
  /// Cliente HTTP de la aplicación.
  final _dio = AppService.dio;

  /// Obtiene el perfil del usuario autenticado.
  Future<ProfileModel> getMyProfile() async {
    final response = await _dio.get(profileMeEndpoint);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al obtener perfil: ${response.statusMessage}');
    }
  }

  /// Actualiza el perfil del usuario autenticado.
  Future<ProfileModel> updateMyProfile(UpdateProfileRequest request) async {
    final response = await _dio.patch(
      profileMeEndpoint,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al actualizar perfil: ${response.statusMessage}');
    }
  }

  /// Actualiza el avatar del usuario autenticado.
  Future<ProfileModel> updateMyAvatar(UpdateAvatarRequest request) async {
    final response = await _dio.patch(
      profileMeAvatarEndpoint,
      data: request.toJson(),
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Error al actualizar avatar: ${response.statusMessage}');
    }
  }

  /// Cambia la contraseña del usuario autenticado.
  Future<void> changePassword(ChangePasswordRequest request) async {
    final response = await _dio.post(
      changePasswordEndpoint,
      data: request.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cambiar contraseña: ${response.statusMessage}');
    }
  }
}
