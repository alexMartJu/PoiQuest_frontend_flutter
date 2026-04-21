import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';

/// Card de estadísticas de gamificación del usuario.
///
/// Muestra cuatro métricas en fila horizontal: POIs escaneados, rutas completadas,
/// tickets premium comprados y puntos totales acumulados.
///
/// Cada métrica se representa con un [_StatItem] (icono + valor numérico + etiqueta).
/// Se usa en la pantalla de perfil (`ProfilePage`).
class GamificationStatsCard extends StatelessWidget {
  final GamificationProgress progress;

  const GamificationStatsCard({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              icon: Icons.qr_code_scanner,
              value: '${progress.stats.totalScans}',
              label: l10n.gamificationStatsPois,
              color: colorScheme.primary,
            ),
            _StatItem(
              icon: Icons.route,
              value: '${progress.stats.completedRoutes}',
              label: l10n.gamificationStatsRoutes,
              color: colorScheme.secondary,
            ),
            _StatItem(
              icon: Icons.confirmation_number,
              value: '${progress.stats.paidTickets}',
              label: l10n.gamificationStatsEvents,
              color: colorScheme.tertiary,
            ),
            _StatItem(
              icon: Icons.stars_rounded,
              value: '${progress.totalPoints}',
              label: l10n.gamificationStatsPoints,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Elemento visual de una sola estadística dentro de [GamificationStatsCard].
///
/// Apila verticalmente: icono coloreado, valor numérico en negrita y
/// etiqueta descriptiva en `onSurfaceVariant`. El color se pasa desde el padre
/// para diferenciar visualmente cada métrica.
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
