import 'package:dio/dio.dart';
import 'package:poiquest_frontend_flutter/core/utils/app_service.dart';
import 'package:poiquest_frontend_flutter/core/utils/constants.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/data/models/ticket_validation_result_model.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/data/models/validation_history_item_model.dart';

class TicketValidatorRemoteDataSource {
  const TicketValidatorRemoteDataSource();

  Future<TicketValidationResultModel> validateTicket(String qrCode) async {
    try {
      final response = await AppService.dio.post(
        validateTicketEndpoint,
        data: {'qrCode': qrCode},
      );
      return TicketValidationResultModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: validateTicketEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al validar ticket: $e',
      );
    }
  }

  Future<List<ValidationHistoryItemModel>> getHistory(String date) async {
    try {
      final response = await AppService.dio.get(
        validationHistoryEndpoint,
        queryParameters: {'date': date},
      );
      final data = response.data as List<dynamic>;
      return data
          .map((json) => ValidationHistoryItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: validationHistoryEndpoint),
        error: e,
        type: DioExceptionType.unknown,
        message: 'Error inesperado al obtener historial: $e',
      );
    }
  }
}
