import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/scan_result.dart';
import 'package:poiquest_frontend_flutter/features/explore/presentation/providers/explore_providers.dart';

/// Pantalla de escaneo QR de un POI.
///
/// Usa `MobileScanner` para capturar códigos QR con la cámara del dispositivo.
/// Al detectar un QR válido con formato `poiquest://poi/{uuid}`, envía la
/// validación al servidor mediante el caso de uso `ScanPoi`.
///
/// Tras un escaneo exitoso:
/// - Invalida los providers de progreso y navegación para que se refresquen.
/// - Recarga la lista de eventos para actualizar los contadores de progreso.
/// - Muestra el resultado con opción de ver el modelo 3D en AR.
class ExplorePoiScanPage extends ConsumerStatefulWidget {
  final String ticketUuid;
  final String? expectedPoiUuid;

  const ExplorePoiScanPage({
    super.key,
    required this.ticketUuid,
    this.expectedPoiUuid,
  });

  @override
  ConsumerState<ExplorePoiScanPage> createState() =>
      _ExplorePoiScanPageState();
}

class _ExplorePoiScanPageState extends ConsumerState<ExplorePoiScanPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;
  ScanResult? _result;
  String? _error;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  /// Extrae el UUID del POI del valor crudo del código QR.
  /// Formato esperado: `poiquest://poi/{uuid}`
  String? _extractPoiUuid(String rawValue) {
    // QR format: poiquest://poi/{uuid}
    final uri = Uri.tryParse(rawValue);
    if (uri != null &&
        uri.scheme == 'poiquest' &&
        uri.host == 'poi' &&
        uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }
    // Fallback: try direct path format
    final regex = RegExp(r'poiquest://poi/([a-f0-9-]+)', caseSensitive: false);
    final match = regex.firstMatch(rawValue);
    return match?.group(1);
  }

  /// Callback invocado al detectar un código QR. Valida el formato,
  /// comprueba si coincide con el POI esperado (si lo hay) y llama al
  /// caso de uso ScanPoi. En caso de éxito, invalida cachés para refrescar
  /// la UI y muestra el resultado.
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || _result != null) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null) return;

    final poiUuid = _extractPoiUuid(rawValue);
    if (poiUuid == null) return;

    // If we have an expected POI UUID, only allow that one
    if (widget.expectedPoiUuid != null && poiUuid != widget.expectedPoiUuid) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final usecase = ref.read(scanPoiUseCaseProvider);
      final result = await usecase(
        poiUuid: poiUuid,
        ticketUuid: widget.ticketUuid,
      );
      if (mounted) {
        // Invalidar los providers cacheados para que se refresquen al volver
        // a las pantallas de progreso y navegación de ruta.
        ref.invalidate(eventProgressProvider);
        ref.invalidate(routeNavigationProvider);
        // Recargar la lista de eventos para actualizar el contador de progreso
        // visible en las tarjetas de ExploreEventCard.
        final tab = ref.read(exploreTabProvider);
        ref.read(exploreEventsNotifierProvider.notifier).loadEvents(
              status: tab == 0 ? 'active' : 'used',
            );
        setState(() {
          _result = result;
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exploreScanPoi),
      ),
      body: _result != null
          ? _buildScanResult(context, _result!, l10n, c, theme)
          : _buildScanner(context, l10n, c, theme),
    );
  }

  /// Construye la vista del escáner: cámara con MobileScanner, overlay de
  /// instrucciones, indicador de procesamiento y mensaje de error.
  Widget _buildScanner(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme c,
    ThemeData theme,
  ) {
    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: _onDetect,
        ),

        // Overlay with instructions
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: c.scrim.withValues(alpha: 0.54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.exploreScanInstruction,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: c.onPrimary,
                ),
              ),
            ),
          ),
        ),

        // Processing indicator
        if (_isProcessing)
          Container(
            color: c.scrim.withValues(alpha: 0.26),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(l10n.exploreScanProcessing),
                  ],
                ),
              ),
            ),
          ),

        // Error message
        if (_error != null)
          Positioned(
            bottom: 32,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: c.onErrorContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() => _error = null);
                    },
                    child: Text(l10n.exploreScanAgain),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Construye la vista de resultado exitoso: icono de éxito, nombre del POI,
  /// datos curiosos (si existen), botón de AR (si hay modelo 3D) y botón
  /// para volver a la ruta.
  Widget _buildScanResult(
    BuildContext context,
    ScanResult result,
    AppLocalizations l10n,
    ColorScheme c,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Success icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: c.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, size: 48, color: c.success),
          ),
          const SizedBox(height: 16),

          Text(
            l10n.exploreScanSuccess,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            result.poiTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: c.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Interesting data
          if (result.interestingData != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 18, color: c.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.interestingDataLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.interestingData!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // AR button (if model available)
          if (result.modelUrl != null) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.push(
                    '/explore/poi-ar',
                    extra: {
                      'modelUrl': result.modelUrl,
                      'poiTitle': result.poiTitle,
                      'interestingData': result.interestingData,
                    },
                  );
                },
                icon: const Icon(Icons.view_in_ar),
                label: Text(l10n.exploreViewAR),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Back button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: Text(l10n.exploreContinueRoute),
            ),
          ),
        ],
      ),
    );
  }
}
