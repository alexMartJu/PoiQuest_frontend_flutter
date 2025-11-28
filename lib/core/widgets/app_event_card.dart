import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_card.dart';

/// Card reutilizable para mostrar eventos con imagen, título, fecha y ubicación.
/// 
/// Usa [AppCard] como base y añade comportamiento responsive para la imagen.
class AppEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String startDate;
  final String? endDate;
  final String location;
  final VoidCallback? onTap;
  /// Widget opcional mostrado encima del contenido (p. ej., botones de acción).
  final Widget? overlay;

  const AppEventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.startDate,
    this.endDate,
    required this.location,
    this.onTap,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing basado en el ancho disponible
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        
        // Imagen ocupa ~28% del ancho con límites min/max
        final imageWidth = (constraints.maxWidth * 0.28).clamp(84.0, 140.0);
        
        // Altura proporcional a la imagen (ratio ~1.05) con mínimo seguro
        final cardHeight = math.max(imageWidth * 1.05, 110.0);
        
        // CacheWidth optimizado para el tamaño real de renderizado
        final cacheWidth = (imageWidth * devicePixelRatio).round();

        return AppCard(
          leading: _buildEventImage(context, imageWidth, cardHeight, cacheWidth),
          onTap: onTap,
          height: cardHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título - permitir que reduzca si es necesario
                  Flexible(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Info filas en bloque para mantener separación consistente
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        context,
                        Icons.calendar_today_rounded,
                        _buildDateRange(),
                      ),
                      const SizedBox(height: 3),
                      _buildInfoRow(
                        context,
                        Icons.location_on_rounded,
                        location,
                      ),
                    ],
                  ),
                ],
              ),
              if (overlay != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: overlay!,
                ),
            ],
          ),
        );
      },
    );
  }

  String _buildDateRange() {
    if (endDate != null && endDate != startDate) {
      return '$startDate - $endDate';
    }
    return startDate;
  }

  Widget _buildEventImage(
    BuildContext context,
    double imageWidth,
    double cardHeight,
    int cacheWidth,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: imageWidth,
      height: cardHeight,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (ctx, url) => Container(
          color: colorScheme.surfaceContainerHighest,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (ctx, url, err) => _buildPlaceholder(ctx),
        imageBuilder: (ctx, imageProvider) {
          // Use ResizeImage para decodificar al tamaño exacto necesario
          final resized = ResizeImage(imageProvider, width: cacheWidth);
          return Image(
            image: resized,
            width: imageWidth,
            height: cardHeight,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
