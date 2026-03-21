import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/route_detail.dart';
import 'package:poiquest_frontend_flutter/features/events/presentation/providers/events_providers.dart';

/// Pantalla de detalle de una ruta. Muestra nombre, descripción, mapa con
/// marcadores numerados + polilínea, y una lista de POIs ordenados.
class RouteDetailPage extends ConsumerWidget {
  final String uuid;

  const RouteDetailPage({super.key, required this.uuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRoute = ref.watch(routeDetailProvider(uuid));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: asyncRoute.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorBody(
          message: l10n.errorLoadingDetail,
          onRetry: () => ref.invalidate(routeDetailProvider(uuid)),
          l10n: l10n,
        ),
        data: (route) => _RouteDetailBody(route: route),
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

class _RouteDetailBody extends StatelessWidget {
  final RouteDetail route;

  const _RouteDetailBody({required this.route});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Collect POI points that have coordinates, sorted by sortOrder
    final sortedPois = List.of(route.pois)..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final poiPoints = sortedPois
        .where((e) => e.poi.coordX != null && e.poi.coordY != null)
        .toList();

    return CustomScrollView(
      slivers: [
        // AppBar
        SliverAppBar(
          pinned: true,
          leading: const _CircularBackButton(),
          title: Text(
            l10n.routeDetailTitle,
            style: TextStyle(color: c.textPrimary),
          ),
          centerTitle: true,
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route name
                Text(
                  route.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),

                // Stops count
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.pin_drop_outlined, size: 16, color: c.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      '${route.pois.length} ${l10n.stopsLabel.toLowerCase()}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),

                // Description
                if (route.description != null && route.description!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.descriptionLabel),
                  const SizedBox(height: 8),
                  Text(
                    route.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],

                // Map with markers and polylines
                if (poiPoints.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.locationLabel),
                  const SizedBox(height: 12),
                  _RouteMap(poiPoints: poiPoints),
                ],

                // POI list
                if (sortedPois.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.pointsOfInterestLabel),
                  const SizedBox(height: 8),
                  ...sortedPois.map(
                    (entry) => _TappablePoiTile(
                      index: entry.sortOrder,
                      title: entry.poi.title,
                      onTap: () => context.push('/points-of-interest/${entry.poi.uuid}'),
                    ),
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

/// Mapa OpenStreetMap que dibuja una polilínea conectando los POIs
/// en orden y coloca marcadores numerados en cada parada.
class _RouteMap extends StatelessWidget {
  final List poiPoints;

  const _RouteMap({required this.poiPoints});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final latLngs = poiPoints
        .map((e) => LatLng(e.poi.coordX!, e.poi.coordY!))
        .toList();

    // Calculate bounds to fit all markers
    final bounds = LatLngBounds.fromPoints(latLngs);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 300,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: bounds.center,
            initialZoom: 13,
            initialCameraFit: latLngs.length > 1
                ? CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(40),
                  )
                : null,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.poiquest_frontend_flutter',
            ),
            // Polyline connecting POIs in order
            if (latLngs.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: latLngs,
                    color: c.primary.withValues(alpha: 0.7),
                    strokeWidth: 3,
                  ),
                ],
              ),
            // Numbered markers
            MarkerLayer(
              markers: List.generate(poiPoints.length, (i) {
                final entry = poiPoints[i];
                final point = LatLng(entry.poi.coordX!, entry.poi.coordY!);
                return Marker(
                  point: point,
                  width: 32,
                  height: 32,
                  child: _NumberedMarker(number: entry.sortOrder),
                );
              }),
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

class _NumberedMarker extends StatelessWidget {
  final int number;

  const _NumberedMarker({required this.number});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: c.primary,
        shape: BoxShape.circle,
        border: Border.all(color: c.onPrimary, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: c.onPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Tile de POI con número circular (consistente con los marcadores del mapa)
/// que navega al detalle del POI al pulsarlo.
class _TappablePoiTile extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback onTap;

  const _TappablePoiTile({
    required this.index,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: c.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: c.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: c.textPrimary,
                        ),
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: c.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
