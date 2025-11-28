import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/utils/date_utils.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_event_card.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filter_chip.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event_category.dart';
import 'package:poiquest_frontend_flutter/features/events/presentation/providers/events_providers.dart';

/// Página principal de Events.
///
/// Responsabilidades:
/// - Mostrar filtros de categoría (chips) y título/subtítulo.
/// - Mantener un `CustomScrollView` con el listado paginado de eventos.
/// - Escuchar el `eventsNotifierProvider` para renderizar estados:
///   loading, empty, error, lista con paginación y footer de fin de lista.
/// - Iniciar la carga inicial en `initState` y detectar scroll para cargar
///   más páginas (infinite scroll).
///
///

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Cargar eventos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usar la categoría seleccionada actualmente (null = All)
      final selected = ref.read(selectedCategoryProvider);
      ref.read(eventsNotifierProvider.notifier).loadEvents(selected?.uuid);
    });

    // Detectar scroll para cargar más eventos
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Cargar más cuando esté cerca del final
      ref.read(eventsNotifierProvider.notifier).loadMoreEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoriesAsync = ref.watch(eventCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final eventsState = ref.watch(eventsNotifierProvider);

    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [

            // Encabezado: título y subtítulo
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.discoverEvents,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.findAmazingEvents,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filtros de categorías
            SliverToBoxAdapter(
              child: categoriesAsync.when(
                data: (categories) => _buildCategoryFilters(
                  context,
                  categories,
                  selectedCategory,
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.errorLoadingCategories(error.toString()),
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ),
            ),

            // Título de eventos destacados
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Text(
                  AppLocalizations.of(context)!.featuredEvents,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // Lista de eventos
            _buildEventsList(eventsState, colorScheme),
          ],
        ),
      );
  }

  Widget _buildCategoryFilters(
    BuildContext context,
    List<EventCategory> categories,
    EventCategory? selectedCategory,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Chip "All"
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AppFilterChip(
              label: AppLocalizations.of(context)!.allCategories,
              selected: selectedCategory == null,
              onSelected: () {
                ref.read(selectedCategoryProvider.notifier).select(null);
                ref.read(eventsNotifierProvider.notifier).loadEvents(null);
              },
            ),
          ),

          // Chips de categorías
          ...categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AppFilterChip(
                label: category.name,
                selected: selectedCategory?.uuid == category.uuid,
                onSelected: () {
                  ref.read(selectedCategoryProvider.notifier).select(category);
                  ref.read(eventsNotifierProvider.notifier).loadEvents(category.uuid);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEventsList(EventsState state, ColorScheme colorScheme) {
    // Estado de carga inicial
    if (state.isLoading && state.events.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Estado de error
    if (state.error != null && state.events.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.errorLoadingEvents,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref.read(eventsNotifierProvider.notifier).refresh();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      );
    }

    // Estado vacío
    if (state.events.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy_rounded,
                size: 64,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noEventsAvailable,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.tryAnotherCategory,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Lista de eventos con indicador de carga al final
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Mostrar eventos
          if (index < state.events.length) {
            final event = state.events[index];
            return AppEventCard(
              imageUrl: event.primaryImageUrl ?? '',
              title: event.name,
              startDate: _formatDate(context, event.startDate),
              endDate: event.endDate != null ? _formatDate(context, event.endDate!) : null,
              location: event.location ?? AppLocalizations.of(context)!.noLocation,
              onTap: () {
                // TODO: Navegar a detalle del evento
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Event: ${event.name}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            );
          }

          // Footer: si hay más páginas mostramos spinner SOLO mientras se esté cargando.
          if (state.hasNextPage) {
            if (state.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              // Hay más páginas pero todavía no se ha disparado la carga.
              // Dejamos un espaciador para permitir hacer scroll y disparar la carga.
              return const SizedBox(height: 24);
            }
          }

          // Mensaje de fin
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.noMoreEvents,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
        childCount: state.events.length + 1,
      ),
    );
  }

  String _formatDate(BuildContext context, String dateStr) {
    // Usa helper centralizado (mes completo) con la locale del contexto
    return formatDateLongFromIsoWithContext(context, dateStr);
  }
}
