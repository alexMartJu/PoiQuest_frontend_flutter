import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_segmented_button.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/providers/explore_providers.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/widgets/explore_event_card.dart';

/// Página principal de Explore.
///
/// Responsabilidades:
/// - Mostrar filtros de estado con `SegmentedButton` (Activos / Usados).
/// - Mantener un `ListView.builder` con el listado paginado de eventos de exploración.
/// - Escuchar el `exploreEventsNotifierProvider` para renderizar estados:
///   loading, empty, error, lista con paginación y footer de fin de lista.
/// - Iniciar la carga inicial en `initState` y detectar scroll para cargar
///   más páginas (infinite scroll).
class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  /// Controlador de scroll compartido entre el ListView y el detector
  /// de infinite scroll para cargar más páginas de eventos.
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Registra el listener de scroll para detectar el final de la lista.
    _scrollController.addListener(_onScroll);
    // Cargar solo si no hay datos previos (preserva estado al navegar
    // de vuelta desde el detalle de un evento).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(exploreEventsNotifierProvider);
      if (state.events.isEmpty && !state.isLoading) {
        _loadForCurrentTab();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Detecta cuando el usuario se acerca al final de la lista (200 px)
  /// y solicita la siguiente página al notifier de exploración.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final tab = ref.read(exploreTabProvider);
      final status = tab == 0 ? 'active' : 'used';
      ref.read(exploreEventsNotifierProvider.notifier).loadMore(status: status);
    }
  }

  /// Traduce el tab seleccionado (0 = activos, 1 = usados) al status
  /// correspondiente y lanza la carga inicial de eventos.
  void _loadForCurrentTab() {
    final tab = ref.read(exploreTabProvider);
    final status = tab == 0 ? 'active' : 'used';
    ref.read(exploreEventsNotifierProvider.notifier).loadEvents(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedTab = ref.watch(exploreTabProvider);
    final eventsState = ref.watch(exploreEventsNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Título de la sección ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                l10n.navExplore,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Segmented Button: filtra entre tickets activos y usados ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppSegmentedButton<int>(
                segments: [
                  ButtonSegment(
                    value: 0,
                    label: Text(l10n.exploreActiveTab),
                    icon: const Icon(Icons.confirmation_number_outlined),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text(l10n.exploreUsedTab),
                    icon: const Icon(Icons.history),
                  ),
                ],
                selected: {selectedTab},
                onSelectionChanged: (selected) {
                  // Al cambiar de tab, actualizar el provider y recargar
                  // la lista desde la primera página.
                  ref.read(exploreTabProvider.notifier).state = selected.first;
                  final status = selected.first == 0 ? 'active' : 'used';
                  ref
                      .read(exploreEventsNotifierProvider.notifier)
                      .loadEvents(status: status);
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── Lista de eventos con infinite scroll ──
            Expanded(
              child: _buildEventsList(context, eventsState, l10n, c),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el cuerpo principal de la lista de eventos.
  ///
  /// Gestiona 4 estados posibles:
  /// - Carga inicial → spinner centrado.
  /// - Error sin datos → mensaje de error con botón de reintentar.
  /// - Lista vacía → placeholder con icono y texto según el tab actual.
  /// - Con datos → `ListView.builder` con `RefreshIndicator` para pull-to-refresh
  ///   e infinite scroll. Añade un item extra cuando `isLoadingMore` es true
  ///   para mostrar un spinner al final de la lista.
  Widget _buildEventsList(
    BuildContext context,
    ExploreEventsState eventsState,
    AppLocalizations l10n,
    ColorScheme c,
  ) {
    if (eventsState.isLoading && eventsState.events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventsState.error != null && eventsState.events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: c.error),
              const SizedBox(height: 16),
              Text(
                eventsState.error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadForCurrentTab,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retryButton),
              ),
            ],
          ),
        ),
      );
    }

    if (eventsState.events.isEmpty) {
      final tab = ref.read(exploreTabProvider);
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tab == 0
                  ? Icons.confirmation_number_outlined
                  : Icons.history,
              size: 56,
              color: c.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              tab == 0
                  ? l10n.noActiveExploreEvents
                  : l10n.noUsedExploreEvents,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: c.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadForCurrentTab(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        itemCount:
            eventsState.events.length + (eventsState.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == eventsState.events.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final event = eventsState.events[index];
          return ExploreEventCard(event: event);
        },
      ),
    );
  }
}
