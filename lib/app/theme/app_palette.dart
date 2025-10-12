import 'package:flutter/material.dart';

class AppPalette {
  final Color primary;       // Texto principal / íconos activos
  final Color onPrimary;
  final Color secondary;     // Verde (estado activo)
  final Color onSecondary;
  final Color warning;       // Dorado / logros
  final Color onWarning;
  final Color danger;        // Rojo (acciones destructivas)
  final Color onDanger;
  final Color background;    // Fondo general
  final Color surface;       // Tarjetas, appbars
  final Color textPrimary;
  final Color textSecondary;
  final Color border;

  const AppPalette({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.warning,
    required this.onWarning,
    required this.danger,
    required this.onDanger,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
  });
}

// Paleta para Tema claro (principal)
const appPaletteLight = AppPalette(
  primary: Color(0xFF111827),
  onPrimary: Colors.white,
  secondary: Color(0xFF16A34A),
  onSecondary: Colors.white,
  warning: Color(0xFFFACC15),
  onWarning: Color(0xFF111827),
  danger: Color(0xFFDC2626),
  onDanger: Colors.white,
  background: Color(0xFFF9FAFB),
  surface: Colors.white,
  textPrimary: Color(0xFF111827),
  textSecondary: Color(0xFF6B7280),
  border: Color(0xFFE5E7EB),
);

// Paleta para Tema oscuro
const appPaletteDark = AppPalette(
  primary: Colors.white,
  onPrimary: Color(0xFF0B0B0B),
  secondary: Color(0xFF4ADE80),
  onSecondary: Color(0xFF0B0B0B),
  warning: Color(0xFFEAB308),
  onWarning: Color(0xFF0B0B0B),
  danger: Color(0xFFF87171),
  onDanger: Color(0xFF0B0B0B),
  background: Color(0xFF111827),
  surface: Color(0xFF1F2937),
  textPrimary: Colors.white,
  textSecondary: Color(0xFF9CA3AF),
  border: Color(0xFF374151),
);

AppPalette appPaletteOf(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? appPaletteDark : appPaletteLight;
}

