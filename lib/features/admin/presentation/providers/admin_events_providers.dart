import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/admin/data/datasources/admin_events_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/admin/data/repositories/admin_events_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/admin/domain/repositories/admin_events_repository.dart';
import 'package:poiquest_frontend_flutter/features/admin/domain/usecases/get_active_events_usecases.dart';
import 'package:poiquest_frontend_flutter/features/admin/domain/usecases/create_event_usecases.dart';
import 'package:poiquest_frontend_flutter/features/admin/domain/usecases/update_event_usecases.dart';
import 'package:poiquest_frontend_flutter/features/admin/domain/usecases/delete_event_usecases.dart';
import 'package:poiquest_frontend_flutter/features/admin/domain/usecases/get_event_categories_usecases.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';

/// Providers para la feature admin de eventos.

// Provider del data source remoto
final adminEventsRemoteDataSourceProvider = Provider<AdminEventsRemoteDataSource>((ref) {
  return const AdminEventsRemoteDataSource();
});

// Provider del repositorio
final adminEventsRepositoryProvider = Provider<AdminEventsRepository>((ref) {
  final dataSource = ref.watch(adminEventsRemoteDataSourceProvider);
  return AdminEventsRepositoryImpl(remoteDataSource: dataSource);
});

// Usecase providers
final getActiveEventsUseCaseProvider = Provider<GetActiveEvents>((ref) {
  final repo = ref.watch(adminEventsRepositoryProvider);
  return GetActiveEvents(repo);
});

final createEventUseCaseProvider = Provider<CreateEvent>((ref) {
  final repo = ref.watch(adminEventsRepositoryProvider);
  return CreateEvent(repo);
});

final updateEventUseCaseProvider = Provider<UpdateEvent>((ref) {
  final repo = ref.watch(adminEventsRepositoryProvider);
  return UpdateEvent(repo);
});

final deleteEventUseCaseProvider = Provider<DeleteEvent>((ref) {
  final repo = ref.watch(adminEventsRepositoryProvider);
  return DeleteEvent(repo);
});

final getEventCategoriesUseCaseProvider = Provider<GetEventCategories>((ref) {
  final repo = ref.watch(adminEventsRepositoryProvider);
  return GetEventCategories(repo);
});

// Provider para obtener las categorías
final adminEventCategoriesProvider = FutureProvider<List<EventCategory>>((ref) async {
  final usecase = ref.watch(getEventCategoriesUseCaseProvider);
  return usecase();
});

// Estado inmutable para eventos activos
class AdminEventsState {
  final List<Event> events;
  final String? nextCursor;
  final bool hasNextPage;
  final bool isLoading;
  final String? error;

  const AdminEventsState({
    this.events = const [],
    this.nextCursor,
    this.hasNextPage = false,
    this.isLoading = false,
    this.error,
  });

  AdminEventsState copyWith({
    List<Event>? events,
    String? Function()? nextCursor,
    bool? hasNextPage,
    bool? isLoading,
    String? Function()? error,
  }) {
    return AdminEventsState(
      events: events ?? this.events,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }
}

// Notifier para gestionar el listado de eventos activos
class AdminEventsNotifier extends Notifier<AdminEventsState> {
  @override
  AdminEventsState build() {
    return const AdminEventsState();
  }

  GetActiveEvents get _getActiveEvents => ref.read(getActiveEventsUseCaseProvider);
  CreateEvent get _createEvent => ref.read(createEventUseCaseProvider);
  UpdateEvent get _updateEvent => ref.read(updateEventUseCaseProvider);
  DeleteEvent get _deleteEvent => ref.read(deleteEventUseCaseProvider);

  /// Carga eventos activos
  Future<void> loadEvents() async {
    state = const AdminEventsState(isLoading: true);

    try {
      final result = await _getActiveEvents.call(limit: 5);

      state = AdminEventsState(
        events: result.events,
        nextCursor: result.nextCursor,
        hasNextPage: result.hasNextPage,
        isLoading: false,
      );
    } catch (e) {
      state = AdminEventsState(
        events: const [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Carga más eventos (scroll infinito)
  Future<void> loadMoreEvents() async {
    if (state.isLoading || !state.hasNextPage) return;

    state = state.copyWith(isLoading: true, error: () => null);

    try {
      final result = await _getActiveEvents.call(
        cursor: state.nextCursor,
        limit: 5,
      );

      state = AdminEventsState(
        events: [...state.events, ...result.events],
        nextCursor: result.nextCursor,
        hasNextPage: result.hasNextPage,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: () => e.toString(),
      );
    }
  }

  /// Crea un nuevo evento y lo agrega al inicio de la lista
  Future<Event> createNewEvent({
    required String name,
    String? description,
    required String categoryUuid,
    String? location,
    required String startDate,
    String? endDate,
    required List<String> imageUrls,
  }) async {
    try {
      final newEvent = await _createEvent.call(
        name: name,
        description: description,
        categoryUuid: categoryUuid,
        location: location,
        startDate: startDate,
        endDate: endDate,
        imageUrls: imageUrls,
      );

      // Agregar el nuevo evento al inicio de la lista
      state = state.copyWith(
        events: [newEvent, ...state.events],
      );

      return newEvent;
    } catch (e) {
      rethrow;
    }
  }

  /// Actualiza un evento existente y lo refresca en la lista
  Future<Event> updateExistingEvent({
    required String uuid,
    String? name,
    String? description,
    String? categoryUuid,
    String? location,
    String? startDate,
    String? endDate,
    List<String>? imageUrls,
  }) async {
    try {
      final updatedEvent = await _updateEvent.call(
        uuid: uuid,
        name: name,
        description: description,
        categoryUuid: categoryUuid,
        location: location,
        startDate: startDate,
        endDate: endDate,
        imageUrls: imageUrls,
      );

      // Reemplazar el evento en la lista
      final updatedList = state.events.map((e) {
        return e.uuid == uuid ? updatedEvent : e;
      }).toList();

      state = state.copyWith(events: updatedList);

      return updatedEvent;
    } catch (e) {
      rethrow;
    }
  }

  /// Elimina un evento y lo quita de la lista
  Future<void> removeEvent(String uuid) async {
    try {
      await _deleteEvent.call(uuid);

      // Quitar el evento de la lista
      final updatedList = state.events.where((e) => e.uuid != uuid).toList();
      state = state.copyWith(events: updatedList);
    } catch (e) {
      rethrow;
    }
  }

  /// Refresca la lista actual
  Future<void> refresh() async {
    await loadEvents();
  }
}

// Provider del notifier de eventos activos
final adminEventsNotifierProvider = NotifierProvider<AdminEventsNotifier, AdminEventsState>(() {
  return AdminEventsNotifier();
});
