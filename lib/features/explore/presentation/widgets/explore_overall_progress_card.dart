import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_progress_bar.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';

/// Card con la barra de progreso global del evento.
///
/// Muestra el número de POIs escaneados sobre el total y una barra
/// de progreso lineal ([AppProgressBar]). La barra cambia a color `success`
/// cuando se alcanza el 100 %, proporcionando feedback visual inmediato.
///
/// Se usa en ExploreEventDetailPage debajo de la información del evento.
class ExploreOverallProgressCard extends StatelessWidget {
  final EventProgress progress;
  final AppLocalizations l10n;

  const ExploreOverallProgressCard({
    super.key,
    required this.progress,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final fraction =
        progress.totalPois > 0 ? progress.scannedPois / progress.totalPois : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
            Text(
              l10n.exploreOverallProgress,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppProgressBar(
                    value: fraction,
                    minHeight: 8,
                    color: fraction >= 1.0 ? c.success : c.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${progress.scannedPois}/${progress.totalPois}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.explorePoisScanned,
              style: theme.textTheme.bodySmall?.copyWith(
                color: c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
