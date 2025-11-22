import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:poiquest_frontend_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/entities/user.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/usecases/get_current_user_usecases.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/usecases/login_usecases.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/usecases/logout_usecases.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/usecases/logout_all_usecases.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/usecases/refresh_token_usecases.dart';
import 'package:poiquest_frontend_flutter/features/auth/domain/usecases/register_standard_user_usecases.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';

/// Provider del datasource local de autenticación.
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

/// Provider del repositorio de autenticación.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

/// Providers de casos de uso (siguen el patrón de `events`: usan `watch`
/// para que, si el repositorio cambia (por ejemplo en tests), los usecases
/// se vuelvan a crear con la nueva instancia automáticamente).
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final logoutAllUseCaseProvider = Provider<LogoutAllUseCase>((ref) {
  return LogoutAllUseCase(ref.watch(authRepositoryProvider));
});

final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  return RefreshTokenUseCase(ref.watch(authRepositoryProvider));
});

final registerStandardUserUseCaseProvider = Provider<RegisterStandardUserUseCase>((ref) {
  return RegisterStandardUserUseCase(ref.watch(authRepositoryProvider));
});

/// Provider del estado de autenticación del usuario.
/// 
/// Gestiona el estado global del usuario autenticado usando AsyncNotifier.
class AuthProvider extends AsyncNotifier<User?> {
  late final AuthRepository _repository;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final LoginUseCase _loginUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final LogoutAllUseCase _logoutAllUseCase;
  late final RefreshTokenUseCase _refreshTokenUseCase;
  late final RegisterStandardUserUseCase _registerStandardUserUseCase;

  @override
  Future<User?> build() async {
    _repository = ref.read(authRepositoryProvider);
    _getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
    _loginUseCase = ref.read(loginUseCaseProvider);
    _logoutUseCase = ref.read(logoutUseCaseProvider);
    _logoutAllUseCase = ref.read(logoutAllUseCaseProvider);
    _refreshTokenUseCase = ref.read(refreshTokenUseCaseProvider);
    _registerStandardUserUseCase = ref.read(registerStandardUserUseCaseProvider);
    
    try {
      // print('AuthProvider: Checking existing authentication...');
      // Intentar leer el token del almacenamiento
      final token = await _repository.readToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      // print('AuthProvider: Token found, fetching user data...');
      // Si hay token, obtener los datos del usuario
      final user = await _getCurrentUserUseCase();

      // Registrar callback para manejar expiración de sesión desde interceptores
      AppService.onSessionExpired = () async {
        // Actualizar estado local a null (no autenticado)
        state = const AsyncData(null);
        // Asegurarse de limpiar tokens en el backend/local (no obligatorio)
        try {
          await _logoutUseCase();
        } catch (_) {}
      };

      return user;
    } catch (_) {
      // print('AuthProvider: Error fetching user data, logging out.');
      // Si hay algún error, cerrar sesión y devolver null
      await _logoutUseCase();
      return null;
    }
  }

  /// Inicia sesión con email y contraseña.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await _loginUseCase(email: email, password: password);
      final user = await _getCurrentUserUseCase();
      // Registrar callback para manejar expiración de sesión
      AppService.onSessionExpired = () async {
        state = const AsyncData(null);
        try {
          await _logoutUseCase();
        } catch (_) {}
      };
      state = AsyncData(user);
    } catch (e, st) {
      // ignore: avoid_print
      print('AuthProvider.signIn -> error during signIn: $e');
      state = AsyncError(e, st);
      state = const AsyncData(null);
      rethrow;
    }
  }

  /// Registra un nuevo usuario estándar.
  Future<void> signUp({
    required String name,
    required String lastname,
    required String email,
    required String password,
    String? avatarUrl,
    String? bio,
  }) async {
    state = const AsyncLoading();
    try {
      // Registrar el usuario en el backend
      await _registerStandardUserUseCase(
        name: name,
        lastname: lastname,
        email: email,
        password: password,
        avatarUrl: avatarUrl,
        bio: bio,
      );

      // No iniciar sesión automáticamente tras el registro. Muchos
      // backends no devuelven tokens al registrarse y el comportamiento
      // deseado es que el usuario quede registrado pero no logueado.
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      state = const AsyncData(null);
      rethrow;
    }
  }

  /// Cierra la sesión del dispositivo actual.
  Future<void> signOut() async {
    await _logoutUseCase();
    AppService.onSessionExpired = null;
    state = const AsyncData(null);
  }

  /// Cierra todas las sesiones del usuario.
  Future<void> signOutAll() async {
    await _logoutAllUseCase();
    AppService.onSessionExpired = null;
    state = const AsyncData(null);
  }

  /// Refresca el token de acceso.
  Future<void> refreshToken() async {
    try {
      await _refreshTokenUseCase();
    } catch (e) {
      // Si falla el refresh, cerrar sesión
      await signOut();
      rethrow;
    }
  }

  /// Recarga el perfil del usuario.
  Future<User> reloadProfile() async {
    final user = await _getCurrentUserUseCase();
    state = AsyncData(user);
    return user;
  }
}

/// Provider del notificador de autenticación.
final authProvider = AsyncNotifierProvider<AuthProvider, User?>(() {
  return AuthProvider();
});
