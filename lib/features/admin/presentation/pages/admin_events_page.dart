import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/utils/date_utils.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_dialog.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/features/admin/presentation/providers/admin_events_providers.dart';
import 'package:poiquest_frontend_flutter/features/admin/presentation/widgets/admin_event_card.dart';
import 'package:poiquest_frontend_flutter/features/admin/presentation/widgets/admin_event_form_bottom_sheet.dart';

/// Página de administración de eventos activos.
/// 
/// Muestra listado paginado de eventos activos con scroll infinito.
/// Permite crear, editar y eliminar eventos mediante acciones en las cards.
class AdminEventsPage extends ConsumerStatefulWidget {
  const AdminEventsPage({super.key});

  @override
  ConsumerState<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends ConsumerState<AdminEventsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar eventos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminEventsNotifierProvider.notifier).loadEvents();
    });

    // Listener para scroll infinito
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminEventsNotifierProvider.notifier).loadMoreEvents();
    }
  }

  void _showCreateEventSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AdminEventFormBottomSheet(),
    );
  }

  void _showEditEventSheet(event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdminEventFormBottomSheet(event: event),
    );
  }

  Future<void> _confirmDeleteEvent(String uuid) async {
    final confirmed = await AppDialog.showConfirm(
      context,
      title: AppLocalizations.of(context)!.deleteevent,
      content: AppLocalizations.of(context)!.deleteeventconfirm,
      confirmLabel: AppLocalizations.of(context)!.delete,
      cancelLabel: AppLocalizations.of(context)!.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(adminEventsNotifierProvider.notifier).removeEvent(uuid);
        if (mounted) {
          AppSnackBar.success(context, AppLocalizations.of(context)!.eventdeletedsuccessfully);
        }
      } catch (e) {
        if (mounted) {
          AppSnackBar.error(context, 'Error: ${e.toString()}');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminEventsNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FloatingActionButton(
          onPressed: _showCreateEventSheet,
          backgroundColor: theme.colorScheme.success,
          foregroundColor: theme.colorScheme.onSuccess,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
            // Encabezado
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.activeevents,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.manageevents,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading inicial
            if (state.isLoading && state.events.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),

            // Error
            if (state.error != null && state.events.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.errorLoadingEvents,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      AppFilledButton(
                        onPressed: () => ref.read(adminEventsNotifierProvider.notifier).refresh(),
                        icon: Icons.refresh,
                        label: AppLocalizations.of(context)!.retry,
                      ),
                    ],
                  ),
                ),
              ),

            // Lista vacía
            if (state.events.isEmpty && !state.isLoading && state.error == null)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.noEventsAvailable,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.adminCreateFirstEventHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Lista de eventos + footer integrado (spinner / spacer / mensaje "no more")
            if (state.events.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Items normales
                    if (index < state.events.length) {
                      final event = state.events[index];
                      final primaryImageUrl = event.primaryImageUrl ?? '';

                      return AdminEventCard(
                        imageUrl: primaryImageUrl,
                        title: event.name,
                        startDate: _formatDate(context, event.startDate),
                        endDate: event.endDate != null
                            ? _formatDate(context, event.endDate!)
                            : null,
                        location: event.location ?? AppLocalizations.of(context)!.noLocation,
                        onEdit: () => _showEditEventSheet(event),
                        onDelete: () => _confirmDeleteEvent(event.uuid),
                      );
                    }

                    // Footer reservado (index == state.events.length)
                    // Si hay más páginas: mostrar spinner SOLO mientras se esté cargando,
                    // si no se está cargando devolver un espaciador para permitir hacer scroll
                    if (state.hasNextPage) {
                      return state.isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox(height: 24);
                    }

                    // No hay más páginas -> mensaje fin de lista
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noMoreEvents,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: state.events.length + 1,
                ),
              ),

            
          ],
        ),
    );
  }

  String _formatDate(BuildContext context, String dateStr) {
    // Delega el formato de fecha a la función de utils
    return formatDateLongFromIsoWithContext(context, dateStr);
  }
}
