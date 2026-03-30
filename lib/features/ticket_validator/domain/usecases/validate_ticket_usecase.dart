import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/ticket_validation_result.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/repositories/ticket_validator_repository.dart';

/// Caso de uso para validar un ticket mediante su código QR.
class ValidateTicket {
  final TicketValidatorRepository _repository;

  const ValidateTicket(this._repository);

  Future<TicketValidationResult> call(String qrCode) {
    return _repository.validateTicket(qrCode);
  }
}
