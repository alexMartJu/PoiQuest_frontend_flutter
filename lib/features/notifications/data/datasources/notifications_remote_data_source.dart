import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/notifications/data/models/notification_model.dart';

class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource();

  Future<({List<NotificationModel> items, int? nextCursor})> getNotifications({
    int? cursor,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await AppService.dio.get(
        notificationsEndpoint,
        queryParameters: queryParams,
      );
      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final items = (body['data'] as List)
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final nextCursor = body['nextCursor'] as int?;
        return (items: items, nextCursor: nextCursor);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener notificaciones: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: notificationsEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener notificaciones: $e',
      );
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await AppService.dio.get(notificationsUnreadCountEndpoint);
      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        return body['count'] as int;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al obtener conteo de no leídas: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: notificationsUnreadCountEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener conteo de no leídas: $e',
      );
    }
  }

  Future<NotificationModel> markAsRead(int id) async {
    try {
      final endpoint = notificationMarkReadEndpoint(id);
      final response = await AppService.dio.patch(endpoint);
      if (response.statusCode == 200) {
        return NotificationModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Error al marcar notificación como leída: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: notificationsEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al marcar notificación como leída: $e',
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await AppService.dio.patch(notificationsMarkAllReadEndpoint);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: notificationsMarkAllReadEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al marcar todas las notificaciones como leídas: $e',
      );
    }
  }
}
