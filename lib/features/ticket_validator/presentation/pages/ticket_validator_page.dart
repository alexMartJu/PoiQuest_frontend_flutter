import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/domain/entities/ticket_validation_result.dart';
import 'package:poiquest_frontend_flutter/features/ticket_validator/presentation/providers/ticket_validator_providers.dart';

class TicketValidatorPage extends ConsumerStatefulWidget {
  const TicketValidatorPage({super.key});

  @override
  ConsumerState<TicketValidatorPage> createState() =>
      _TicketValidatorPageState();
}

class _TicketValidatorPageState extends ConsumerState<TicketValidatorPage>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;
  TicketValidationResult? _lastResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) return;

    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_controller.start());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        unawaited(_controller.stop());
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final ticketUuid = barcode.rawValue!;

    setState(() => _isProcessing = true);
    await _controller.stop();

    try {
      final useCase = ref.read(validateTicketUseCaseProvider);
      final result = await useCase(ticketUuid);

      if (!mounted) return;

      setState(() => _lastResult = result);

      if (result.valid) {
        AppSnackBar.show(
          context,
          message: AppLocalizations.of(context)!.scannerSuccess,
          variant: AppSnackBarVariant.success,
        );
      } else {
        AppSnackBar.show(
          context,
          message: AppLocalizations.of(context)!.scannerInvalid,
          variant: AppSnackBarVariant.error,
        );
      }
    } catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      final message = e.toString().contains('404')
          ? l10n.scannerNotFound
          : l10n.scannerError;

      AppSnackBar.show(
        context,
        message: message,
        variant: AppSnackBarVariant.error,
      );

      setState(() {
        _lastResult = null;
        _isProcessing = false;
      });
      await _controller.start();
    }
  }

  Future<void> _scanAnother() async {
    ref.invalidate(validationHistoryProvider);
    setState(() {
      _isProcessing = false;
      _lastResult = null;
    });
    await _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Scanner area
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Camera preview
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder: (context, error) {
                    return _CameraErrorView(
                      message: l10n.cameraPermissionDenied,
                    );
                  },
                ),
              ),

              // Scanner overlay
              const _ScannerOverlay(),

              // Processing indicator
              if (_isProcessing && _lastResult == null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.scannerProcessing,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Top instruction
              if (!_isProcessing)
                Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        l10n.scannerSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Result / scan another area
        Expanded(
          flex: 2,
          child: _lastResult != null
              ? _ValidationResultCard(
                  result: _lastResult!,
                  onScanAnother: _scanAnother,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 48,
                        color: colorScheme.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.scannerTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.scannerSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

/// Overlay with a QR-shaped viewfinder cutout.
class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final scanSize = constraints.maxWidth * 0.65;
        final left = (constraints.maxWidth - scanSize) / 2;
        final top = (constraints.maxHeight - scanSize) / 2;

        return Stack(
          children: [
            // Semi-transparent dark overlay with cutout
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: scanSize,
                      height: scanSize,
                      decoration: BoxDecoration(
                        color: Colors.red, // any color, will be cut out
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Corner brackets
            Positioned(
              left: left,
              top: top,
              child: _CornerBracket(
                color: colorScheme.primary,
                alignment: Alignment.topLeft,
              ),
            ),
            Positioned(
              right: left,
              top: top,
              child: _CornerBracket(
                color: colorScheme.primary,
                alignment: Alignment.topRight,
              ),
            ),
            Positioned(
              left: left,
              bottom: constraints.maxHeight - top - scanSize,
              child: _CornerBracket(
                color: colorScheme.primary,
                alignment: Alignment.bottomLeft,
              ),
            ),
            Positioned(
              right: left,
              bottom: constraints.maxHeight - top - scanSize,
              child: _CornerBracket(
                color: colorScheme.primary,
                alignment: Alignment.bottomRight,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A single corner bracket of the viewfinder.
class _CornerBracket extends StatelessWidget {
  final Color color;
  final Alignment alignment;

  const _CornerBracket({required this.color, required this.alignment});

  @override
  Widget build(BuildContext context) {
    const size = 28.0;
    const thickness = 3.5;

    final isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(
          color: color,
          thickness: thickness,
          isTop: isTop,
          isLeft: isLeft,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool isTop;
  final bool isLeft;

  _CornerPainter({
    required this.color,
    required this.thickness,
    required this.isTop,
    required this.isLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (isTop && isLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) =>
      color != oldDelegate.color || thickness != oldDelegate.thickness;
}

/// Card showing the validation result with event details.
class _ValidationResultCard extends StatelessWidget {
  final TicketValidationResult result;
  final VoidCallback onScanAnother;

  const _ValidationResultCard({
    required this.result,
    required this.onScanAnother,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final statusColor =
        result.valid ? colorScheme.secondary : colorScheme.error;
    final statusIcon =
        result.valid ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final statusLabel = result.valid ? l10n.validLabel : l10n.invalidLabel;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Status icon + label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, color: statusColor, size: 28),
              const SizedBox(width: 8),
              Text(
                statusLabel,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Event details
          Expanded(
            child: Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (result.eventName != null)
                      _DetailRow(
                        label: l10n.eventLabel,
                        value: result.eventName!,
                      ),
                    if (result.eventCity != null) ...[
                      const SizedBox(height: 8),
                      _DetailRow(
                        label: l10n.cityLabel,
                        value: result.eventCity!,
                      ),
                    ],
                    const SizedBox(height: 8),
                    _DetailRow(
                      label: l10n.dateLabel,
                      value: result.visitDate,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Scan another button
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: onScanAnother,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(l10n.scanAnother),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  final String message;

  const _CameraErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.videocam_off_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
