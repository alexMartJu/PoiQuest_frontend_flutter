import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/repositories/tickets_repository.dart';

class GetUsedTickets {
  final TicketsRepository repository;

  GetUsedTickets(this.repository);

  Future<List<Ticket>> call() => repository.getUsedTickets();
}
