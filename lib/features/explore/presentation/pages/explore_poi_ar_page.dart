import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plus/arcore_flutter_plus.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_fab.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';

/// Pantalla de realidad aumentada de un POI.
///
/// Descarga un modelo 3D (.glb) desde la URL proporcionada, lo muestra
/// usando ARCore y permite al usuario rotarlo y ver información del POI
/// en un panel inferior arrastrable.
///
/// Notas técnicas:
/// - Usa `UniqueKey` en `ArCoreView` para forzar una instancia nativa nueva
///   cada vez que se abre la página, evitando crashes por reutilización.
/// - NO llama a `_arCoreController?.dispose()` en `dispose()` porque el
///   framework de platform views libera la vista nativa automáticamente.
///   Hacerlo manualmente provoca `NullPointerException` en `onResume`.
/// - El flag `_isDisposed` previene actualizaciones de estado después de
///   que el widget se haya desmontado.
class ExplorePoiArPage extends StatefulWidget {
  final String? modelUrl;
  final String poiTitle;
  final String? interestingData;

  const ExplorePoiArPage({
    super.key,
    this.modelUrl,
    required this.poiTitle,
    this.interestingData,
  });

  @override
  State<ExplorePoiArPage> createState() => _ExplorePoiArPageState();
}

class _ExplorePoiArPageState extends State<ExplorePoiArPage> {
  ArCoreController? _arCoreController;
  bool _modelPlaced = false;
  bool _modelLoading = false;
  bool _showInfo = true;
  String? _localModelPath;
  String? _loadError;
  double _rotationY = 0.0;
  double _infoPanelHeight = 180.0;
  bool _isDisposed = false;
  final _arViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (widget.modelUrl != null) {
      _downloadModel();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    // NO llamar _arCoreController?.dispose() — al hacerlo se destruye la
    // vista nativa (ArSceneView) antes de que Flutter libere el platform view.
    // Esto provoca que getView() devuelva null y lance NullPointerException
    // tanto en VirtualDisplayController.dispose como en onResume/resetSurface.
    // El framework de platform views se encarga de liberar la vista nativa
    // automáticamente al eliminar el widget del árbol.
    _arCoreController = null;
    // Clean up temp file
    if (_localModelPath != null) {
      File(_localModelPath!).delete().ignore();
    }
    super.dispose();
  }

  /// Descarga el modelo 3D desde la URL remota a un archivo temporal local.
  /// ARCore requiere un archivo local para cargar modelos .glb.
  Future<void> _downloadModel() async {
    setState(() {
      _modelLoading = true;
      _loadError = null;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/poi_model_${DateTime.now().millisecondsSinceEpoch}.glb';
      
      await Dio().download(widget.modelUrl!, filePath);
      
      if (mounted && !_isDisposed) {
        setState(() {
          _localModelPath = filePath;
          _modelLoading = false;
        });
        // If AR view is already created, place the model now
        if (_arCoreController != null) {
          _placeModel();
        }
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() {
          _modelLoading = false;
          _loadError = e.toString();
        });
      }
    }
  }

  /// Callback invocado cuando la vista AR nativa está lista.
  /// Si el modelo ya se descargó, lo coloca inmediatamente.
  void _onArCoreViewCreated(ArCoreController controller) {
    if (_isDisposed) return;
    _arCoreController = controller;

    // If model is already downloaded, place it
    if (_localModelPath != null) {
      _placeModel();
    }
  }

  /// Crea un nodo ARCore con el modelo .glb y lo posiciona a 1.5 m
  /// delante de la cámara. Si ya existe un modelo, lo reemplaza
  /// (usado también al rotar).
  Future<void> _placeModel() async {
    if (_isDisposed || _arCoreController == null || _localModelPath == null) {
      return;
    }

    // Remove existing model if any
    if (_modelPlaced) {
      _arCoreController?.removeNode(nodeName: 'poi_model');
      setState(() => _modelPlaced = false);
    }

    final node = ArCoreReferenceNode(
      name: 'poi_model',
      objectUrl: 'file://$_localModelPath',
      position: vector.Vector3(0, 0, -1.5),
      scale: vector.Vector3(1.0, 1.0, 1.0),
      rotation: vector.Vector4(
        0,
        math.sin(_rotationY / 2),
        0,
        math.cos(_rotationY / 2),
      ),
    );

    _arCoreController?.addArCoreNode(node);
    setState(() => _modelPlaced = true);
  }

  /// Rota el modelo sobre el eje Y los grados indicados.
  /// Recoloca el nodo con la nueva rotación aplicada.
  void _rotateModel(double degrees) {
    _rotationY += degrees * math.pi / 180;
    if (_modelPlaced) _placeModel();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exploreArTitle),
      ),
      body: widget.modelUrl == null
          ? _buildNoModel(c, theme, l10n)
          : _modelLoading
              ? _buildLoading(c, theme, l10n)
              : _loadError != null
                  ? _buildError(c, theme, l10n)
                  : Stack(
              children: [
                // AR Camera View — UniqueKey fuerza una instancia nativa
                // nueva, evitando conflictos al reabrir la página.
                ArCoreView(
                  key: _arViewKey,
                  onArCoreViewCreated: _onArCoreViewCreated,
                  enableTapRecognizer: false,
                  enablePlaneRenderer: true,
                ),

                // Bottom controls + info panel
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Action buttons row
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              // Rotation controls
                              Row(
                                children: [
                                  AppFab(
                                    heroTag: 'rotate_left',
                                    icon: Icons.rotate_left,
                                    size: AppFabSize.small,
                                    onPressed: () => _rotateModel(-30),
                                  ),
                                  const SizedBox(width: 8),
                                  AppFab(
                                    heroTag: 'rotate_right',
                                    icon: Icons.rotate_right,
                                    size: AppFabSize.small,
                                    onPressed: () => _rotateModel(30),
                                  ),
                                ],
                              ),
                              // Refresh + info toggle
                              Row(
                                children: [
                                  if (_modelPlaced)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8),
                                      child: AppFab(
                                        heroTag: 'refresh',
                                        icon: Icons.refresh,
                                        size: AppFabSize.small,
                                        onPressed: () {
                                          _rotationY = 0;
                                          _placeModel();
                                        },
                                      ),
                                    ),
                                  AppFab(
                                    heroTag: 'info_toggle',
                                    icon: _showInfo
                                        ? Icons.expand_more
                                        : Icons.info_outline,
                                    size: AppFabSize.small,
                                    onPressed: () => setState(() {
                                      _showInfo = !_showInfo;
                                      if (_showInfo) {
                                        _infoPanelHeight = 180.0;
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Draggable info panel
                        if (_showInfo &&
                            (widget.interestingData != null ||
                                _modelPlaced))
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setState(() {
                                _infoPanelHeight =
                                    (_infoPanelHeight -
                                            details.delta.dy)
                                        .clamp(100.0, 350.0);
                              });
                            },
                            onVerticalDragEnd: (_) {
                              if (_infoPanelHeight < 120) {
                                setState(() {
                                  _showInfo = false;
                                  _infoPanelHeight = 180.0;
                                });
                              }
                            },
                            child: Container(
                              height: _infoPanelHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: c.surface,
                                borderRadius:
                                    const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: c.scrim
                                        .withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, -2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Drag handle
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8, bottom: 4),
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: c.outline
                                          .withValues(alpha: 0.3),
                                      borderRadius:
                                          BorderRadius.circular(2),
                                    ),
                                  ),
                                  // Scrollable content
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding:
                                          const EdgeInsets.fromLTRB(
                                              16, 8, 16, 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.poiTitle,
                                            style: theme
                                                .textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight:
                                                  FontWeight.w700,
                                              color: c.textPrimary,
                                            ),
                                          ),
                                          if (widget.interestingData !=
                                              null) ...[
                                            const SizedBox(height: 8),
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.all(
                                                      12),
                                              decoration: BoxDecoration(
                                                color: c
                                                    .surfaceContainerLow,
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                border: Border.all(
                                                    color: c.border),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .lightbulb_outline,
                                                    size: 18,
                                                    color: c.primary,
                                                  ),
                                                  const SizedBox(
                                                      width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      widget
                                                          .interestingData!,
                                                      style: theme
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        color: c
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoading(
      ColorScheme c, ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            l10n.exploreArLoading,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(
      ColorScheme c, ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: c.error),
          const SizedBox(height: 12),
          Text(
            l10n.exploreNoModel,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          AppFilledButton(
            label: l10n.retry,
            icon: Icons.refresh,
            onPressed: _downloadModel,
          ),
        ],
      ),
    );
  }

  Widget _buildNoModel(
      ColorScheme c, ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.view_in_ar_outlined, size: 64, color: c.outline),
          const SizedBox(height: 12),
          Text(
            l10n.exploreNoModel,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
