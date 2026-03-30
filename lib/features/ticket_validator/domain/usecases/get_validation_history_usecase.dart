import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/validation_history_item.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/repositories/ticket_validator_repository.dart';

/// Caso de uso para obtener el historial de validaciones por fecha.
class GetValidationHistory {
  final TicketValidatorRepository _repository;

  const GetValidationHistory(this._repository);

  Future<List<ValidationHistoryItem>> call(String date) {
    return _repository.getHistory(date);
  }
}
