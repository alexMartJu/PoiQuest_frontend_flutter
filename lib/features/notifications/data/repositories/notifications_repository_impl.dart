import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/notifications/domain/entities/app_notification.dart';
import 'package:poiquest_frontend_flutter/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl({required this.remoteDataSource});
  final NotificationsRemoteDataSource remoteDataSource;

  @override
  Future<({List<AppNotification> items, int? nextCursor})> getNotifications({
    int? cursor,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getNotifications(cursor: cursor, limit: limit);
      return (
        items: result.items.map((m) => m.toEntity()).toList(),
        nextCursor: result.nextCursor,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al obtener notificaciones: $e');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      return await remoteDataSource.getUnreadCount();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al obtener notificaciones no leídas: $e');
    }
  }

  @override
  Future<AppNotification> markAsRead(int id) async {
    try {
      final model = await remoteDataSource.markAsRead(id);
      return model.toEntity();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al marcar notificación como leída: $e');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Error inesperado al marcar todas las notificaciones como leídas: $e');
    }
  }

  /// Manejo centralizado de errores de Dio
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Error de conexión: Tiempo de espera agotado');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return Exception('Solicitud inválida');
          case 401:
            return Exception('No autorizado');
          case 403:
            return Exception('Acceso prohibido');
          case 404:
            return Exception('Recurso no encontrado');
          case 500:
            return Exception('Error del servidor');
          default:
            return Exception('Error del servidor: $statusCode');
        }

      case DioExceptionType.cancel:
        return Exception('Solicitud cancelada');

      case DioExceptionType.connectionError:
        return Exception('Error de conexión: Verifica tu conexión a internet');

      case DioExceptionType.badCertificate:
        return Exception('Error de certificado SSL');

      case DioExceptionType.unknown:
        return Exception('Error inesperado: ${error.message}');
    }
  }
}
