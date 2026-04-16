import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_fab.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/route_navigation.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/providers/explore_providers.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/widgets/explore_poi_chip.dart';

/// Pantalla de navegación de una ruta con mapa interactivo.
///
/// Responsabilidades:
/// - Mostrar un mapa OpenStreetMap (flutter_map) con marcadores para cada POI.
/// - Rastrear la ubicación GPS del usuario en tiempo real (geolocator).
/// - Detectar proximidad automática (≤15 m) a un POI no escaneado y
///   mostrar un SnackBar con la opción de escanear.
/// - Mostrar chips horizontales en la parte inferior para centrar el mapa
///   en cada POI al pulsarlos.
/// - Gestionar permisos de ubicación y estados de error.
class ExploreRouteNavigationPage extends ConsumerStatefulWidget {
  final String routeUuid;
  final String ticketUuid;

  const ExploreRouteNavigationPage({
    super.key,
    required this.routeUuid,
    required this.ticketUuid,
  });

  @override
  ConsumerState<ExploreRouteNavigationPage> createState() =>
      _ExploreRouteNavigationPageState();
}

class _ExploreRouteNavigationPageState
    extends ConsumerState<ExploreRouteNavigationPage> {
  /// Controlador del mapa para mover/centrar programáticamente.
  final _mapController = MapController();

  /// Suscripción al stream de posiciones GPS del dispositivo.
  StreamSubscription<Position>? _positionSub;

  /// Última posición conocida del usuario (null hasta obtener la primera).
  LatLng? _currentPosition;

  /// Indica si hubo un error al obtener permisos o servicio de ubicación.
  bool _locationError = false;

  /// Set de UUIDs de POIs para los que ya se mostró el prompt de escaneo
  /// (evita mostrar el mismo SnackBar varias veces).
  final Set<String> _triggeredPois = {};

  /// Radio en metros para considerar que el usuario está cerca de un POI.
  static const double _scanRadiusMeters = 15.0;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  /// Solicita permisos de ubicación y comienza a escuchar la posición
  /// del dispositivo. En cada actualización recalcula la proximidad a POIs.
  Future<void> _initLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationError = true);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationError = true);
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() => _locationError = true);
      return;
    }

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen(
      (position) {
        final newPos = LatLng(position.latitude, position.longitude);
        setState(() => _currentPosition = newPos);
        _checkProximity(newPos);
      },
      onError: (_) {
        setState(() => _locationError = true);
      },
    );
  }

  /// Comprueba la distancia del usuario a cada POI no escaneado.
  /// Si está dentro del radio de escaneo, muestra un SnackBar de aviso.
  void _checkProximity(LatLng userPos) {
    final navState = ref.read(routeNavigationProvider(
      (routeUuid: widget.routeUuid, ticketUuid: widget.ticketUuid),
    ));

    final routeNav = navState.asData?.value;
    if (routeNav == null) return;

    for (final poi in routeNav.pois) {
      if (poi.scanned || _triggeredPois.contains(poi.uuid)) continue;
      if (poi.coordX == null || poi.coordY == null) continue;

      final distance = _distanceInMeters(
        userPos.latitude,
        userPos.longitude,
        poi.coordX!,
        poi.coordY!,
      );

      if (distance <= _scanRadiusMeters) {
        _triggeredPois.add(poi.uuid);
        _showScanPrompt(poi);
        break;
      }
    }
  }

  /// Calcula la distancia en metros entre dos coordenadas usando la fórmula
  /// de Haversine. Suficiente precisión para distancias cortas (<1 km).
  double _distanceInMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  /// Muestra un SnackBar informando al usuario que está cerca de un POI
  /// con un botón de acción para ir directamente a la pantalla de escaneo QR.
  void _showScanPrompt(NavigationPoi poi) {
    final l10n = AppLocalizations.of(context)!;
    AppSnackBar.show(
      context,
      message: '${l10n.exploreNearPoi}: ${poi.title}',
      variant: AppSnackBarVariant.info,
      duration: const Duration(seconds: 8),
      action: SnackBarAction(
        label: l10n.navScan,
        onPressed: () {
          context.push(
            '/explore/scan-poi',
            extra: {
              'ticketUuid': widget.ticketUuid,
              'poiUuid': poi.uuid,
              'poiQrCode': poi.qrCode,
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final asyncNav = ref.watch(routeNavigationProvider(
      (routeUuid: widget.routeUuid, ticketUuid: widget.ticketUuid),
    ));

    return Scaffold(
      appBar: AppBar(
        title: asyncNav.whenOrNull(
              data: (nav) => Text(nav.name),
            ) ??
            Text(l10n.exploreRouteNavigation),
      ),
      body: asyncNav.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48,
                  color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(error.toString()),
              const SizedBox(height: 16),
              AppFilledButton(
                label: l10n.retryButton,
                icon: Icons.refresh,
                onPressed: () => ref.invalidate(routeNavigationProvider(
                  (routeUuid: widget.routeUuid, ticketUuid: widget.ticketUuid),
                )),
              ),
            ],
          ),
        ),
        data: (routeNav) => _buildMap(context, routeNav, l10n),
      ),
      floatingActionButton: _currentPosition != null
          ? AppFab(
              heroTag: 'my_location',
              icon: Icons.my_location,
              size: AppFabSize.small,
              onPressed: () {
                _mapController.move(_currentPosition!, 17);
              },
            )
          : null,
    );
  }

  /// Construye el mapa OpenStreetMap con marcadores de POIs y usuario.
  ///
  /// Estructura del Stack:
  /// 1. `FlutterMap` — mapa con TileLayer de OSM + MarkerLayer (user + POIs).
  /// 2. Banner de error de ubicación (si aplica).
  /// 3. Lista horizontal inferior de chips de POIs para centrar el mapa.
  Widget _buildMap(
    BuildContext context,
    RouteNavigation routeNav,
    AppLocalizations l10n,
  ) {
    final c = Theme.of(context).colorScheme;
    final poisWithCoords = routeNav.pois
        .where((p) => p.coordX != null && p.coordY != null)
        .toList();

    // Center on first POI or user position
    final center = _currentPosition ??
        (poisWithCoords.isNotEmpty
            ? LatLng(poisWithCoords.first.coordX!, poisWithCoords.first.coordY!)
            : const LatLng(40.4168, -3.7038));

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.poiquest.app',
            ),
            MarkerLayer(
              markers: [
                // User position marker
                if (_currentPosition != null)
                  Marker(
                    point: _currentPosition!,
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: c.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: c.onPrimary, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: c.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                // POI markers
                ...poisWithCoords.map((poi) => Marker(
                      point: LatLng(poi.coordX!, poi.coordY!),
                      width: 36,
                      height: 36,
                      child: GestureDetector(
                        onTap: () {
                          if (!poi.scanned) {
                            context.push(
                              '/explore/scan-poi',
                              extra: {
                                'ticketUuid': widget.ticketUuid,
                                'poiUuid': poi.uuid,
                                'poiQrCode': poi.qrCode,
                              },
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: poi.scanned ? c.success : c.primary,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: c.onPrimary, width: 2),
                          ),
                          child: Center(
                            child: poi.scanned
                                ? Icon(Icons.check,
                                    size: 18, color: c.onPrimary)
                                : Text(
                                    '${poi.sortOrder}',
                                    style: TextStyle(
                                      color: c.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),

        // Location error banner
        if (_locationError)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MaterialBanner(
              content: Text(l10n.exploreLocationError),
              backgroundColor: c.warning.withValues(alpha: 0.15),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => _locationError = false);
                    _initLocation();
                  },
                  child: Text(l10n.retryButton),
                ),
              ],
            ),
          ),

        // Bottom POI list
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 140),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: c.scrim.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              itemCount: routeNav.pois.length,
              itemBuilder: (context, index) {
                final poi = routeNav.pois[index];
                return ExplorePoiChip(
                  poi: poi,
                  onTap: () {
                    if (poi.coordX != null && poi.coordY != null) {
                      _mapController.move(
                        LatLng(poi.coordX!, poi.coordY!),
                        17,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
