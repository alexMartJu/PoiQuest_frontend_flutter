import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/tickets/data/models/ticket_model.dart';
import 'package:poiquest_frontend_flutter/features/tickets/data/models/event_availability_model.dart';

class TicketsRemoteDataSource {
  const TicketsRemoteDataSource();

  Future<({String clientSecret, String paymentIntentId})> createPaymentIntent({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  }) async {
    try {
      final response = await AppService.dio.post(
        createPaymentIntentEndpoint,
        data: {
          'eventUuid': eventUuid,
          'visitDate': visitDate,
          'quantity': quantity,
        },
      );
      final body = response.data as Map<String, dynamic>;
      return (
        clientSecret: body['clientSecret'] as String,
        paymentIntentId: body['paymentIntentId'] as String,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: createPaymentIntentEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al crear PaymentIntent: $e',
      );
    }
  }

  Future<void> confirmPayment(String paymentIntentId) async {
    try {
      await AppService.dio.post(
        confirmPaymentEndpoint,
        data: {'paymentIntentId': paymentIntentId},
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: confirmPaymentEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al confirmar pago: $e',
      );
    }
  }

  Future<List<String>> createFreeTickets({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  }) async {
    try {
      final response = await AppService.dio.post(
        createFreeTicketsEndpoint,
        data: {
          'eventUuid': eventUuid,
          'visitDate': visitDate,
          'quantity': quantity,
        },
      );
      final body = response.data as Map<String, dynamic>;
      final ticketUuids = (body['ticketUuids'] as List).cast<String>();
      return ticketUuids;
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: createFreeTicketsEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al crear tickets gratuitos: $e',
      );
    }
  }

  Future<List<TicketModel>> getActiveTickets() async {
    try {
      final response = await AppService.dio.get(activeTicketsEndpoint);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => TicketModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: activeTicketsEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener tickets activos: $e',
      );
    }
  }

  Future<List<TicketModel>> getUsedTickets() async {
    try {
      final response = await AppService.dio.get(usedTicketsEndpoint);
      final data = response.data as List<dynamic>;
      return data
          .map((json) => TicketModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: usedTicketsEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener tickets usados: $e',
      );
    }
  }

  Future<EventAvailabilityModel> getEventAvailability(
    String eventUuid,
    String visitDate,
  ) async {
    try {
      final response = await AppService.dio.get(
        eventAvailabilityEndpoint(eventUuid, visitDate),
      );
      return EventAvailabilityModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/payments/availability'),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al consultar disponibilidad: $e',
      );
    }
  }
}
