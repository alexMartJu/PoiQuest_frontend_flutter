import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_progress_bar.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/widgets/explore_poi_list_tile.dart';

/// Card de ruta dentro del detalle de progreso de un evento.
///
/// Estructura vertical:
/// 1. Cabecera: icono de ruta + nombre + contador (escaneados/total).
/// 2. Barra de progreso lineal (cambia a verde al completar).
/// 3. Lista de POIs con estado de escaneo ([ExplorePoiListTile]).
/// 4. Botón "Iniciar ruta" que navega a la pantalla de mapa.
///    Deshabilitado si el ticket no está desbloqueado (`isUnlocked = false`).
class ExploreRouteCard extends StatelessWidget {
  final RouteProgress route;
  final String ticketUuid;
  final bool isUnlocked;
  final AppLocalizations l10n;

  const ExploreRouteCard({
    super.key,
    required this.route,
    required this.ticketUuid,
    required this.isUnlocked,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final fraction =
        route.totalPois > 0 ? route.scannedPois / route.totalPois : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route name + progress count
            Row(
              children: [
                Icon(Icons.route, size: 20, color: c.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    route.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${route.scannedPois}/${route.totalPois}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress bar
            AppProgressBar(
              value: fraction,
              minHeight: 6,
              borderRadius: 4,
              color: fraction >= 1.0 ? c.success : c.primary,
            ),
            const SizedBox(height: 12),

            // POI list
            ...route.pois.map((poi) => ExplorePoiListTile(poi: poi)),

            const SizedBox(height: 8),

            // Start route button
            SizedBox(
              width: double.infinity,
              child: AppFilledButton(
                label: l10n.exploreStartRoute,
                icon: Icons.navigation_outlined,
                onPressed: isUnlocked
                    ? () {
                        context.push(
                          '/explore/routes/${route.uuid}/navigation',
                          extra: {'ticketUuid': ticketUuid},
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
