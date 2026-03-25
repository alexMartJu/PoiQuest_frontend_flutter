import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/tickets/data/datasources/tickets_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/tickets/data/repositories/tickets_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/event_availability.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/repositories/tickets_repository.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/usecases/get_active_tickets_usecase.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/usecases/get_used_tickets_usecase.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/usecases/purchase_tickets_usecase.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/usecases/get_event_availability_usecase.dart';

// Data source
final ticketsRemoteDataSourceProvider = Provider<TicketsRemoteDataSource>((ref) {
  return const TicketsRemoteDataSource();
});

// Repository
final ticketsRepositoryProvider = Provider<TicketsRepository>((ref) {
  final dataSource = ref.watch(ticketsRemoteDataSourceProvider);
  return TicketsRepositoryImpl(remoteDataSource: dataSource);
});

// Use cases
final getActiveTicketsUseCaseProvider = Provider<GetActiveTickets>((ref) {
  return GetActiveTickets(ref.watch(ticketsRepositoryProvider));
});

final getUsedTicketsUseCaseProvider = Provider<GetUsedTickets>((ref) {
  return GetUsedTickets(ref.watch(ticketsRepositoryProvider));
});

final purchaseTicketsUseCaseProvider = Provider<PurchaseTickets>((ref) {
  return PurchaseTickets(ref.watch(ticketsRepositoryProvider));
});

final getEventAvailabilityUseCaseProvider = Provider<GetEventAvailability>((ref) {
  return GetEventAvailability(ref.watch(ticketsRepositoryProvider));
});

// Active tickets
final activeTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  final usecase = ref.watch(getActiveTicketsUseCaseProvider);
  return usecase();
});

// Used tickets
final usedTicketsProvider = FutureProvider<List<Ticket>>((ref) async {
  final usecase = ref.watch(getUsedTicketsUseCaseProvider);
  return usecase();
});

// Event availability (family provider keyed by eventUuid+date)
final eventAvailabilityProvider =
    FutureProvider.family<EventAvailability, ({String eventUuid, String visitDate})>(
  (ref, params) async {
    final usecase = ref.watch(getEventAvailabilityUseCaseProvider);
    return usecase(params.eventUuid, params.visitDate);
  },
);

// Selected tab index (0 = active, 1 = used)
final ticketsTabProvider = NotifierProvider<TicketsTabNotifier, int>(
  () => TicketsTabNotifier(),
);

class TicketsTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  @override
  set state(int value) => super.state = value;
}
