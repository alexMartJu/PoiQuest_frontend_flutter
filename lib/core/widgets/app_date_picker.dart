import 'package:flutter/material.dart';

/// Wrapper para mostrar un Modal Date Picker con estilo M3.
///
/// Usa `showDatePicker` con `initialEntryMode: DatePickerEntryMode.calendarOnly`
/// para una experiencia limpia y centrada en el calendario.
class AppDatePicker {
  /// Muestra un date picker modal y devuelve la fecha seleccionada.
  ///
  /// [context] - BuildContext necesario para el diálogo
  /// [initialDate] - Fecha inicial seleccionada (por defecto hoy)
  /// [firstDate] - Fecha mínima seleccionable (por defecto hoy)
  /// [lastDate] - Fecha máxima seleccionable (por defecto +2 años)
  /// [helpText] - Texto de ayuda mostrado en el header del picker
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
  }) async {
    final now = DateTime.now();
    final effectiveInitial = initialDate ?? now;
    final effectiveFirst = firstDate ?? now;
    final effectiveLast = lastDate ?? DateTime(now.year + 2, 12, 31);

    // Asegurar que initialDate está dentro del rango válido
    final clampedInitial = effectiveInitial.isBefore(effectiveFirst)
        ? effectiveFirst
        : effectiveInitial.isAfter(effectiveLast)
            ? effectiveLast
            : effectiveInitial;

    return showDatePicker(
      context: context,
      initialDate: clampedInitial,
      firstDate: effectiveFirst,
      lastDate: effectiveLast,
      helpText: helpText,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
  }
}
