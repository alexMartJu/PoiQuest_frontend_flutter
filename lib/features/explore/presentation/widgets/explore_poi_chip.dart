import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/route_navigation.dart';

/// Chip horizontal de un POI en la lista inferior del mapa de navegación.
///
/// Muestra un indicador circular con el número de orden o check si fue
/// escaneado, junto al título del POI. Al pulsarlo, el callback `onTap`
/// centra el mapa en las coordenadas de ese POI.
///
/// Dimensiones fijas de 120 px de ancho para mantener uniformidad
/// en el `ListView` horizontal del mapa.
class ExplorePoiChip extends StatelessWidget {
  final NavigationPoi poi;
  final VoidCallback onTap;

  const ExplorePoiChip({
    super.key,
    required this.poi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: poi.scanned
              ? c.success.withValues(alpha: 0.08)
              : c.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: poi.scanned ? c.success : c.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: poi.scanned ? c.success : c.primary,
                  ),
                  child: Center(
                    child: poi.scanned
                        ? Icon(Icons.check,
                            size: 12, color: c.onPrimary)
                        : Text(
                            '${poi.sortOrder}',
                            style: TextStyle(
                              color: c.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              poi.title,
              style: theme.textTheme.labelSmall?.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
