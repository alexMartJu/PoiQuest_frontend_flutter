import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/features/explore/data/datasources/explore_remote_data_source.dart';
import 'package:poiquest_frontend_flutter/features/explore/data/repositories/explore_repository_impl.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/explore_event.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/route_navigation.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/repositories/explore_repository.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/usecases/get_explore_events_usecase.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/usecases/get_event_progress_usecase.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/usecases/scan_poi_usecase.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/usecases/get_route_navigation_usecase.dart';

/// Providers y Notifiers de la feature `explore`.
///
/// Responsabilidad: exponer las abstracciones necesarias para la capa
/// de presentación (UI) y orquestar la comunicación con la capa de dominio
/// y datos.
///
/// Flujo resumido: `ExplorePage` (UI) -> `exploreEventsNotifierProvider` (Notifier)
/// -> usecases (`GetExploreEvents`, `GetEventProgress`, `ScanPoi`,
/// `GetRouteNavigation`) -> repository -> data source
/// (`ExploreRemoteDataSource`) -> HTTP.
/// 

// Data source
final exploreRemoteDataSourceProvider = Provider<ExploreRemoteDataSource>((ref) {
  return const ExploreRemoteDataSource();
});

// Repository
final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  final dataSource = ref.watch(exploreRemoteDataSourceProvider);
  return ExploreRepositoryImpl(remoteDataSource: dataSource);
});

// Use cases
final getExploreEventsUseCaseProvider = Provider<GetExploreEvents>((ref) {
  return GetExploreEvents(ref.watch(exploreRepositoryProvider));
});

final getEventProgressUseCaseProvider = Provider<GetEventProgress>((ref) {
  return GetEventProgress(ref.watch(exploreRepositoryProvider));
});

final scanPoiUseCaseProvider = Provider<ScanPoi>((ref) {
  return ScanPoi(ref.watch(exploreRepositoryProvider));
});

final getRouteNavigationUseCaseProvider = Provider<GetRouteNavigation>((ref) {
  return GetRouteNavigation(ref.watch(exploreRepositoryProvider));
});

/// Notifier sencillo que guarda el tab seleccionado por el usuario (0 = activos, 1 = usados).
final exploreTabProvider = NotifierProvider<ExploreTabNotifier, int>(
  () => ExploreTabNotifier(),
);

class ExploreTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  @override
  set state(int value) => super.state = value;
}

/// Notifier con paginación para la lista de eventos del modo exploración.
final exploreEventsNotifierProvider =
    NotifierProvider<ExploreEventsNotifier, ExploreEventsState>(
  () => ExploreEventsNotifier(),
);

class ExploreEventsState {
  final List<ExploreEvent> events;
  final bool isLoading;
  final bool isLoadingMore;
  final String? nextCursor;
  final bool hasNextPage;
  final Object? error;

  const ExploreEventsState({
    this.events = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.nextCursor,
    this.hasNextPage = true,
    this.error,
  });

  ExploreEventsState copyWith({
    List<ExploreEvent>? events,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? nextCursor,
    bool? hasNextPage,
    Object? Function()? error,
  }) {
    return ExploreEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      error: error != null ? error() : this.error,
    );
  }
}

class ExploreEventsNotifier extends Notifier<ExploreEventsState> {
  @override
  ExploreEventsState build() {
    return const ExploreEventsState();
  }

  Future<void> loadEvents({required String status}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: () => null);

    try {
      final usecase = ref.read(getExploreEventsUseCaseProvider);
      final result = await usecase(status: status);
      state = ExploreEventsState(
        events: result.data,
        nextCursor: result.nextCursor,
        hasNextPage: result.hasNextPage,
      );
    } catch (e) {
      state = ExploreEventsState(error: e);
    }
  }

  Future<void> loadMore({required String status}) async {
    if (state.isLoadingMore || !state.hasNextPage || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);

    try {
      final usecase = ref.read(getExploreEventsUseCaseProvider);
      final result = await usecase(
        status: status,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        events: [...state.events, ...result.data],
        nextCursor: () => result.nextCursor,
        hasNextPage: result.hasNextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: () => e);
    }
  }
}

/// Provider que obtiene el progreso de un evento (rutas y POIs escaneados).
final eventProgressProvider = FutureProvider.family<EventProgress,
    ({String eventUuid, String visitDate})>((ref, params) async {
  final usecase = ref.watch(getEventProgressUseCaseProvider);
  return usecase(eventUuid: params.eventUuid, visitDate: params.visitDate);
});

/// Provider que obtiene la navegación de una ruta (mapa y lista de POIs).
final routeNavigationProvider = FutureProvider.family<RouteNavigation,
    ({String routeUuid, String ticketUuid})>((ref, params) async {
  final usecase = ref.watch(getRouteNavigationUseCaseProvider);
  return usecase(routeUuid: params.routeUuid, ticketUuid: params.ticketUuid);
});
