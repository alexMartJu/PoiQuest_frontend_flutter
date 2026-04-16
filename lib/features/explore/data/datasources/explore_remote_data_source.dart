import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/explore/data/models/explore_event_model.dart';
import 'package:poiquest_frontend_flutter/features/explore/data/models/event_progress_model.dart';
import 'package:poiquest_frontend_flutter/features/explore/data/models/scan_result_model.dart';
import 'package:poiquest_frontend_flutter/features/explore/data/models/route_navigation_model.dart';

class ExploreRemoteDataSource {
  const ExploreRemoteDataSource();

  Future<({List<ExploreEventModel> data, String? nextCursor, bool hasNextPage})>
      getMyEvents({
    required String status,
    String? cursor,
    int limit = 4,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'status': status,
        'limit': limit,
      };
      if (cursor != null) queryParams['cursor'] = cursor;

      final response = await AppService.dio.get(
        exploreMyEventsEndpoint,
        queryParameters: queryParams,
      );
      final body = response.data as Map<String, dynamic>;
      final dataList = body['data'] as List<dynamic>;
      return (
        data: dataList
            .map((json) =>
                ExploreEventModel.fromJson(json as Map<String, dynamic>))
            .toList(),
        nextCursor: body['nextCursor'] as String?,
        hasNextPage: body['hasNextPage'] as bool,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: exploreMyEventsEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener eventos de exploración: $e',
      );
    }
  }

  Future<EventProgressModel> getEventProgress({
    required String eventUuid,
    required String visitDate,
  }) async {
    try {
      final response = await AppService.dio.get(
        exploreEventProgressEndpoint(eventUuid),
        queryParameters: {'visitDate': visitDate},
      );
      return EventProgressModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/explore/events/$eventUuid/progress'),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener progreso del evento: $e',
      );
    }
  }

  Future<ScanResultModel> scanPoi({
    required String poiUuid,
    required String ticketUuid,
  }) async {
    try {
      final response = await AppService.dio.post(
        exploreScanPoiEndpoint,
        data: {
          'poiUuid': poiUuid,
          'ticketUuid': ticketUuid,
        },
      );
      return ScanResultModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: exploreScanPoiEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al escanear POI: $e',
      );
    }
  }

  Future<RouteNavigationModel> getRouteNavigation({
    required String routeUuid,
    required String ticketUuid,
  }) async {
    try {
      final response = await AppService.dio.get(
        exploreRouteNavigationEndpoint(routeUuid),
        queryParameters: {'ticketUuid': ticketUuid},
      );
      return RouteNavigationModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/explore/routes/$routeUuid/navigation'),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener navegación de ruta: $e',
      );
    }
  }
}
