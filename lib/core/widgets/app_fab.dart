import 'package:flutter/material.dart';

/// Variantes de tamaño para AppFab.
enum AppFabSize {
  small,
  regular,
  large,
  extended,
}

/// Widget reutilizable de FloatingActionButton con Material Design 3 (2024).
///
/// Soporta múltiples tamaños y colores personalizables.
/// Requiere [heroTag] para evitar conflictos cuando hay varios FABs en la misma pantalla.
///
/// Uso:
/// ```dart
/// AppFab(
///   heroTag: 'refresh',
///   icon: Icons.refresh,
///   size: AppFabSize.small,
///   onPressed: () {},
/// )
/// ```
class AppFab extends StatelessWidget {
  /// Icono del FAB.
  final IconData icon;

  /// Callback al presionar el FAB.
  final VoidCallback? onPressed;

  /// Tag único para Hero animation. Requerido cuando hay múltiples FABs.
  final String heroTag;

  /// Tamaño del FAB (small, regular, large, extended).
  final AppFabSize size;

  /// Texto para la variante [AppFabSize.extended].
  final String? label;

  /// Color de fondo. Por defecto usa `colorScheme.primaryContainer`.
  final Color? backgroundColor;

  /// Color del icono/texto. Por defecto usa `colorScheme.onPrimaryContainer`.
  final Color? foregroundColor;

  const AppFab({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.heroTag,
    this.size = AppFabSize.regular,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? c.secondary;
    final fg = foregroundColor ?? c.onPrimaryContainer;

    return switch (size) {
      AppFabSize.small => FloatingActionButton.small(
          heroTag: heroTag,
          onPressed: onPressed,
          backgroundColor: bg,
          foregroundColor: fg,
          child: Icon(icon),
        ),
      AppFabSize.regular => FloatingActionButton(
          heroTag: heroTag,
          onPressed: onPressed,
          backgroundColor: bg,
          foregroundColor: fg,
          child: Icon(icon),
        ),
      AppFabSize.large => FloatingActionButton.large(
          heroTag: heroTag,
          onPressed: onPressed,
          backgroundColor: bg,
          foregroundColor: fg,
          child: Icon(icon),
        ),
      AppFabSize.extended => FloatingActionButton.extended(
          heroTag: heroTag,
          onPressed: onPressed,
          backgroundColor: bg,
          foregroundColor: fg,
          icon: Icon(icon),
          label: Text(label ?? ''),
        ),
    };
  }
}
