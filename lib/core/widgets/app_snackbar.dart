import 'package:flutter/material.dart';

/// Variantes de estilo para AppSnackBar.
enum AppSnackBarVariant {
  info,
  success,
  error,
}

/// Utilidad para mostrar SnackBars reutilizables con variantes de estilo.
/// 
/// Uso:
/// ```dart
/// AppSnackBar.show(
///   context,
///   message: 'Operación exitosa',
///   variant: AppSnackBarVariant.success,
/// );
/// ```
class AppSnackBar {
  /// Muestra un SnackBar con el estilo especificado.
  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarVariant variant = AppSnackBarVariant.info,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Configuración de colores según variante.
    final (backgroundColor, textColor, icon) = switch (variant) {
      AppSnackBarVariant.info => (
          colorScheme.primary,
          colorScheme.onPrimary,
          Icons.info_outline,
        ),
      AppSnackBarVariant.success => (
          colorScheme.secondary,
          colorScheme.onSecondary,
          Icons.check_circle_outline,
        ),
      AppSnackBarVariant.error => (
          colorScheme.error,
          colorScheme.onError,
          Icons.error_outline,
        ),
    };

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      action: action,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Muestra un SnackBar de información (azul).
  static void info(BuildContext context, String message) {
    show(context, message: message, variant: AppSnackBarVariant.info);
  }

  /// Muestra un SnackBar de éxito (verde).
  static void success(BuildContext context, String message) {
    show(context, message: message, variant: AppSnackBarVariant.success);
  }

  /// Muestra un SnackBar de error (rojo).
  static void error(BuildContext context, String message) {
    show(context, message: message, variant: AppSnackBarVariant.error);
  }

  /// Muestra un SnackBar de advertencia (naranja).
  static void warning(BuildContext context, String message) {
    show(context, message: message, variant: AppSnackBarVariant.info);
  }
}
