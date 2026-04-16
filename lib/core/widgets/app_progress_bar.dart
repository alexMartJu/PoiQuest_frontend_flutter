import 'package:flutter/material.dart';

/// Barra de progreso lineal reutilizable con Material Design 3.
///
/// Envuelve `LinearProgressIndicator` en `ClipRRect` para bordes redondeados.
/// Soporta color dinámico según el progreso (completado vs en progreso).
///
/// Uso:
/// ```dart
/// AppProgressBar(
///   value: 0.75,
///   minHeight: 8,
/// )
/// ```
class AppProgressBar extends StatelessWidget {
  /// Valor del progreso (0.0 a 1.0). Si es null muestra animación indeterminada.
  final double? value;

  /// Altura mínima de la barra.
  final double minHeight;

  /// Color de la barra de progreso. Por defecto usa `colorScheme.primary`.
  final Color? color;

  /// Color del fondo de la barra. Por defecto usa `colorScheme.outline` con alpha 0.15.
  final Color? backgroundColor;

  /// Radio de los bordes de la barra.
  final double borderRadius;

  const AppProgressBar({
    super.key,
    this.value,
    this.minHeight = 8,
    this.color,
    this.backgroundColor,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: LinearProgressIndicator(
        value: value,
        minHeight: minHeight,
        backgroundColor: backgroundColor ?? c.outline.withValues(alpha: 0.15),
        color: color ?? c.primary,
      ),
    );
  }
}
