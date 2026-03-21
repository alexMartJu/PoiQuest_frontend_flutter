import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/point_of_interest.dart';
import 'package:poiquest_frontend_flutter/features/events/presentation/providers/events_providers.dart';

/// Pantalla de detalle de un Punto de Interés. Muestra carrusel de imágenes,
/// descripción, datos curiosos y mapa con su ubicación.
class PoiDetailPage extends ConsumerWidget {
  final String uuid;

  const PoiDetailPage({super.key, required this.uuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPoi = ref.watch(poiDetailProvider(uuid));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: asyncPoi.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorBody(
          message: l10n.errorLoadingDetail,
          onRetry: () => ref.invalidate(poiDetailProvider(uuid)),
          l10n: l10n,
        ),
        data: (poi) => _PoiDetailBody(poi: poi),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorBody({
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: c.error),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _PoiDetailBody extends StatelessWidget {
  final PointOfInterest poi;

  const _PoiDetailBody({required this.poi});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasImages = poi.images != null && poi.images!.isNotEmpty;
    final hasCoords = poi.coordX != null && poi.coordY != null;

    return CustomScrollView(
      slivers: [
        // AppBar with back button
        SliverAppBar(
          pinned: true,
          expandedHeight: hasImages ? 300 : 0,
          leading: const _CircularBackButton(),
          flexibleSpace: hasImages
              ? FlexibleSpaceBar(
                  background: _ImageCarousel(images: poi.images!),
                )
              : null,
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  poi.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),

                // Author
                if (poi.author != null && poi.author!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16, color: c.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          poi.author!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],

                // Description
                if (poi.description != null && poi.description!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.descriptionLabel),
                  const SizedBox(height: 8),
                  Text(
                    poi.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],

                // Interesting Data
                if (poi.interestingData != null && poi.interestingData!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.interestingDataLabel),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.border),
                    ),
                    child: Text(
                      poi.interestingData!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: c.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],

                // Map
                if (hasCoords) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.locationLabel),
                  const SizedBox(height: 12),
                  _PoiMap(
                    lat: poi.coordX!,
                    lng: poi.coordY!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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

/// Carrusel de imágenes: muestra imagen única a ancho completo
/// o un CarouselView deslizable si hay varias.
class _ImageCarousel extends StatelessWidget {
  final List images;

  const _ImageCarousel({required this.images});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    if (images.length == 1) {
      return CachedNetworkImage(
        imageUrl: images.first.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300,
        placeholder: (_, __) => Container(color: c.border),
        errorWidget: (_, __, ___) => Container(
          color: c.border,
          child: Icon(Icons.broken_image, color: c.textSecondary, size: 48),
        ),
      );
    }

    return CarouselView(
      itemExtent: MediaQuery.of(context).size.width * 0.85,
      shrinkExtent: MediaQuery.of(context).size.width * 0.85,
      itemSnapping: true,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      children: images.map((img) {
        return CachedNetworkImage(
          imageUrl: img.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
          placeholder: (_, __) => Container(color: c.border),
          errorWidget: (_, __, ___) => Container(
            color: c.border,
            child: Icon(Icons.broken_image, color: c.textSecondary, size: 48),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
    );
  }
}

/// Mapa OpenStreetMap con un marcador en las coordenadas del POI.
class _PoiMap extends StatelessWidget {
  final double lat;
  final double lng;

  const _PoiMap({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final point = LatLng(lat, lng);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 250,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.poiquest_frontend_flutter',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.location_on,
                    color: c.error,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SimpleAttributionWidget(
              source: Text('OpenStreetMap contributors'),
            ),
          ],
        ),
      ),
    );
  }
}
