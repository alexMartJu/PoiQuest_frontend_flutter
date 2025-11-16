import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/events/data/datasources/events_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/events/data/repositories/events_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/repositories/events_repository.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/usecases/get_events_by_category_usecases.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/usecases/get_categories_usecases.dart';

/// Providers y Notifiers de la feature `events`.
///
/// Responsabilidad: exponer las abstracciones necesarias para la capa
/// de presentación (UI) y orquestar la comunicación con la capa de dominio
/// y datos.
///
/// Flujo resumido: `EventsPage` (UI) -> `eventsNotifierProvider` (Notifier)
/// -> usecases (`GetEventsByCategory`, `GetCategories`) -> repository
/// -> data source (`EventsRemoteDataSource`) -> HTTP.

// Provider que expone la instancia del data source HTTP (Dio).
// Se utiliza `const` cuando es posible para optimizar y favorecer la
// inmutabilidad; permite inyectar otra implementación en tests si es necesario.
final eventsRemoteDataSourceProvider = Provider<EventsRemoteDataSource>((ref) {
  return const EventsRemoteDataSource();
});

// Provider del repositorio
final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final dataSource = ref.watch(eventsRemoteDataSourceProvider);
  return EventsRepositoryImpl(remoteDataSource: dataSource);
});

// Usecase providers
final getEventsByCategoryUseCaseProvider = Provider<GetEventsByCategory>((ref) {
  final repo = ref.watch(eventsRepositoryProvider);
  return GetEventsByCategory(repo);
});

final getCategoriesUseCaseProvider = Provider<GetCategories>((ref) {
  final repo = ref.watch(eventsRepositoryProvider);
  return GetCategories(repo);
});

// Provider para obtener las categorías
final eventCategoriesProvider = FutureProvider<List<EventCategory>>((ref) async {
  final usecase = ref.watch(getCategoriesUseCaseProvider);
  return usecase();
});

// Provider para la categoría seleccionada (null = "All")
final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, EventCategory?>(
  () => SelectedCategoryNotifier(),
);

/// Notifier sencillo que guarda la categoría seleccionada por el usuario.
/// Usado por la UI para filtrar eventos.
class SelectedCategoryNotifier extends Notifier<EventCategory?> {
  @override
  EventCategory? build() => null;

  void select(EventCategory? category) {
    state = category;
  }
}

// Provider para el estado de eventos paginados
/// Estado inmutable que contiene:
/// - `events`: lista actual de eventos mostrados en la UI.
/// - `nextCursor`: cursor para obtener la siguiente página (si existe).
/// - `hasNextPage`: indica si hay más páginas en el backend.
/// - `isLoading`: indica una operación de carga en curso (inicial o paginación).
/// - `error`: mensaje de error (si procede).
///
/// El patrón inmutable facilita tests y evita efectos secundarios en la UI.
class EventsState {
  final List<Event> events;
  final String? nextCursor;
  final bool hasNextPage;
  final bool isLoading;
  final String? error;

  const EventsState({
    this.events = const [],
    this.nextCursor,
    this.hasNextPage = false,
    this.isLoading = false,
    this.error,
  });

  EventsState copyWith({
    List<Event>? events,
    String? Function()? nextCursor,
    bool? hasNextPage,
    bool? isLoading,
    String? Function()? error,
  }) {
    return EventsState(
      events: events ?? this.events,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }
}

// Notifier responsable de la lógica de la lista de eventos y paginación.
/// `EventsNotifier` utiliza el caso de uso `GetEventsByCategory` para:
/// - `loadEvents(categoryUuid)`: cargar la primera página para una categoría
///   (o todas si `null`) y reemplazar la lista en el estado.
/// - `loadMoreEvents()`: cargar la siguiente página y concatenarla a la lista
///   existente (infinite scroll).
/// - `refresh()`: recargar la página actual.
///
/// Observaciones:
/// - El tamaño de página (`limit`) se pasa al usecase (por defecto 4).
/// - El notifier mantiene `_currentCategoryUuid` para detectar cambio de
///   categoría y resetear la paginación.
class EventsNotifier extends Notifier<EventsState> {
  String? _currentCategoryUuid;

  @override
  EventsState build() {
    return const EventsState();
  }

  GetEventsByCategory get _getEvents => ref.read(getEventsByCategoryUseCaseProvider);

  /// Carga eventos de una categoría (reemplaza la lista actual)
  Future<void> loadEvents(String? categoryUuid) async {
    if (_currentCategoryUuid != categoryUuid) {
      // Nueva categoría, resetear estado
      state = const EventsState(isLoading: true);
      _currentCategoryUuid = categoryUuid;
    } else {
      // Misma categoría, mantener datos
      state = state.copyWith(isLoading: true, error: () => null);
    }

    try {
      final result = await _getEvents.call(
        categoryUuid: categoryUuid,
        limit: 4,
      );

      state = EventsState(
        events: result.events,
        nextCursor: result.nextCursor,
        hasNextPage: result.hasNextPage,
        isLoading: false,
      );
    } catch (e) {
      state = EventsState(
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
      final result = await _getEvents.call(
        categoryUuid: _currentCategoryUuid,
        cursor: state.nextCursor,
        limit: 4,
      );

      state = EventsState(
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

  /// Refresca la lista actual
  Future<void> refresh() async {
    await loadEvents(_currentCategoryUuid);
  }
}

// Provider del notifier de eventos
final eventsNotifierProvider = NotifierProvider<EventsNotifier, EventsState>(() {
  return EventsNotifier();
});
