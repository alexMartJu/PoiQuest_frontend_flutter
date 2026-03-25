import 'package:poiquest_frontend_flutter/features/tickets/domain/repositories/tickets_repository.dart';

class PurchaseTickets {
  final TicketsRepository repository;

  PurchaseTickets(this.repository);

  /// Para eventos de pago: crea PaymentIntent.
  Future<({String clientSecret, String paymentIntentId})> createPaymentIntent({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  }) {
    return repository.createPaymentIntent(
      eventUuid: eventUuid,
      visitDate: visitDate,
      quantity: quantity,
    );
  }

  /// Confirma un pago completado.
  Future<void> confirmPayment(String paymentIntentId) {
    return repository.confirmPayment(paymentIntentId);
  }

  /// Para eventos gratuitos: obtiene tickets directamente.
  Future<List<String>> createFreeTickets({
    required String eventUuid,
    required String visitDate,
    required int quantity,
  }) {
    return repository.createFreeTickets(
      eventUuid: eventUuid,
      visitDate: visitDate,
      quantity: quantity,
    );
  }
}
