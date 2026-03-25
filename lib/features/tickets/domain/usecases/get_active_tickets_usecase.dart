import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/repositories/tickets_repository.dart';

class GetActiveTickets {
  final TicketsRepository repository;

  GetActiveTickets(this.repository);

  Future<List<Ticket>> call() => repository.getActiveTickets();
}
