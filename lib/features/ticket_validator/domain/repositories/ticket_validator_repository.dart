import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/ticket_validation_result.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/validation_history_item.dart';

/// Repositorio abstracto para operaciones de validación de tickets
abstract class TicketValidatorRepository {
  /// Valida un ticket escaneando su código QR
  Future<TicketValidationResult> validateTicket(String qrCode);

  /// Obtiene el historial de validaciones filtrado por fecha
  Future<List<ValidationHistoryItem>> getHistory(String date);
}
