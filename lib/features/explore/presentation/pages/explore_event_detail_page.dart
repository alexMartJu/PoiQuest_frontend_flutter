import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_badge.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/providers/explore_providers.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/widgets/explore_overall_progress_card.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/widgets/explore_route_card.dart';

/// Pantalla de detalle de un evento en modo exploración.
///
/// Muestra la imagen hero del evento, el progreso global de POIs escaneados,
/// la lista de rutas con sus POIs y un botón para iniciar la navegación
/// de cada ruta.
///
/// Usa `eventProgressProvider` (FutureProvider.family) para obtener el progreso
/// del evento según `eventUuid` y `visitDate`. La lógica de desbloqueo se
/// calcula comparando la fecha de visita del ticket con la fecha actual:
/// - `isUnlocked`: el ticket está `used` Y hoy es el día de visita → puede navegar.
/// - `isReadonly`: el ticket está `used` pero ya pasó la fecha → solo lectura.
/// - Bloqueado: el ticket aún no ha sido validado.
class ExploreEventDetailPage extends ConsumerWidget {
  final String eventUuid;
  final String visitDate;
  final String ticketUuid;
  final String ticketStatus;

  const ExploreEventDetailPage({
    super.key,
    required this.eventUuid,
    required this.visitDate,
    required this.ticketUuid,
    required this.ticketStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Observa el progreso del evento. Se invalida automáticamente al volver
    // de la pantalla de escaneo gracias a ref.invalidate() en ExplorePoiScanPage.
    final asyncProgress = ref.watch(
      eventProgressProvider(
        (eventUuid: eventUuid, visitDate: visitDate),
      ),
    );

    return Scaffold(
      body: asyncProgress.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(context, ref, error, l10n),
        data: (progress) => _buildContent(context, progress, l10n),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    WidgetRef ref,
    Object error,
    AppLocalizations l10n,
  ) {
    final c = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: c.error),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: c.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppFilledButton(
              label: l10n.retryButton,
              icon: Icons.refresh,
              onPressed: () => ref.invalidate(
                eventProgressProvider(
                  (eventUuid: eventUuid, visitDate: visitDate),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    EventProgress progress,
    AppLocalizations l10n,
  ) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    // Comprobar si hoy es el día de visita del ticket para determinar el nivel
    // de acceso: desbloqueado (puede escanear), solo lectura (ya pasó) o bloqueado.
    final today = DateTime.now().toIso8601String().split('T')[0];
    final isVisitDay = progress.visitDate == today;
    final isUsed = progress.ticketStatus == 'used';
    final isUnlocked = isUsed && isVisitDay;
    final isReadonly = isUsed && !isVisitDay;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // ── Imagen hero con botón circular de retroceso ──
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          leading: const _CircularBackButton(),
          flexibleSpace: FlexibleSpaceBar(
            background: progress.primaryImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: progress.primaryImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: c.border),
                    errorWidget: (_, __, ___) => Container(
                      color: c.border,
                      child: Icon(Icons.image_not_supported,
                          color: c.textSecondary, size: 48),
                    ),
                  )
                : Container(
                    color: c.border,
                    child: Icon(Icons.event, color: c.textSecondary, size: 64),
                  ),
          ),
        ),

        // ── Contenido principal: info del evento, progreso y rutas ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Info del evento: izquierda (nombre + fecha/ciudad) | derecha (botón detalle + badge estado) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Izquierda: nombre del evento + fecha y ciudad
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress.eventName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 14, color: c.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              progress.visitDate,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                            if (progress.cityName != null) ...[
                              const SizedBox(width: 12),
                              Icon(Icons.location_on,
                                  size: 14, color: c.textSecondary),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  progress.cityName!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: c.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Derecha: botón "ver detalles" del evento + badge de estado
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppFilledButton(
                        label: l10n.exploreViewDetails,
                        icon: Icons.info_outline,
                        size: AppFilledButtonSize.small,
                        onPressed: () =>
                            context.push('/events/${progress.eventUuid}'),
                      ),
                      const SizedBox(height: 8),
                      AppBadge(
                        label: isUnlocked
                            ? l10n.exploreUnlocked
                            : isReadonly
                                ? l10n.exploreCompleted
                                : l10n.exploreLocked,
                        variant: isUnlocked
                            ? AppBadgeVariant.exploreUnlocked
                            : isReadonly
                                ? AppBadgeVariant.exploreCompleted
                                : AppBadgeVariant.exploreLocked,
                        icon: isUnlocked
                            ? Icons.lock_open
                            : isReadonly
                                ? Icons.visibility
                                : Icons.lock,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Tarjeta de progreso global (barra con POIs escaneados/total) ──
            ExploreOverallProgressCard(progress: progress, l10n: l10n),

            const SizedBox(height: 24),

            // ── Sección de rutas: lista cada ruta con su progreso y POIs ──
            if (progress.routes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.routesLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...progress.routes.map((route) => ExploreRouteCard(
                    route: route,
                    ticketUuid: ticketUuid,
                    isUnlocked: isUnlocked,
                    l10n: l10n,
                  )),
              ],
            ],
          ),
        ),
      ),
    ],
  );
  }
}

/// Botón circular semitransparente de retroceso para la SliverAppBar.
class _CircularBackButton extends StatelessWidget {
  const _CircularBackButton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: c.surface.withValues(alpha: 0.85),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}
