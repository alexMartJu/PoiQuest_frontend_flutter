import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/event_progress.dart';

/// Fila individual de un POI dentro de una ruta.
///
/// Muestra un indicador circular con:
/// - Check verde (`c.success`) si el POI ya fue escaneado.
/// - Número de orden (`sortOrder`) si está pendiente.
///
/// El título aparece tachado con color secundario cuando ya fue escaneado,
/// proporcionando feedback visual claro del estado.
class ExplorePoiListTile extends StatelessWidget {
  final PoiProgress poi;

  const ExplorePoiListTile({super.key, required this.poi});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: poi.scanned
                  ? c.success.withValues(alpha: 0.15)
                  : c.surfaceContainerHighest,
            ),
            child: Center(
              child: poi.scanned
                  ? Icon(Icons.check, size: 14, color: c.success)
                  : Text(
                      '${poi.sortOrder}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: c.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              poi.title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: poi.scanned ? c.textSecondary : c.textPrimary,
                decoration:
                    poi.scanned ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
