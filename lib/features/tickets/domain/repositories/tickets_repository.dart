import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/event_availability.dart';

/// Repositorio abstracto para operaciones de tickets y pagos.
abstract class TicketsRepository {
  /// Crea un PaymentIntent en Stripe para un evento de pago.
  Future<({String clientSecret, String paymentIntentId})> createPaymentIntent({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  });

  /// Confirma un pago completado.
  Future<void> confirmPayment(String paymentIntentId);

  /// Crea tickets gratuitos.
  Future<List<String>> createFreeTickets({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  });

  /// Obtiene los tickets activos del usuario.
  Future<List<Ticket>> getActiveTickets();

  /// Obtiene los tickets usados del usuario.
  Future<List<Ticket>> getUsedTickets();

  /// Consulta disponibilidad de un evento para una fecha.
  Future<EventAvailability> getEventAvailability(String eventUuid, String visitDate);
}
