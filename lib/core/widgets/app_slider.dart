import 'package:flutter/material.dart';

/// Slider de rango de precios estilizado con Material Design 3 (2024).
///
/// Usa `SliderTheme` con `year2023: false` para la variante M3 moderna.
/// Muestra etiquetas con el valor formateado sobre los thumbs.
class AppRangeSlider extends StatelessWidget {
  final double min;
  final double max;
  final double currentMin;
  final double currentMax;
  final ValueChanged<RangeValues> onChanged;
  final String Function(double value)? formatLabel;

  const AppRangeSlider({
    super.key,
    required this.min,
    required this.max,
    required this.currentMin,
    required this.currentMax,
    required this.onChanged,
    this.formatLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliderTheme(
      data: SliderThemeData(
        // M3 2024 - usar la variante moderna sin year2023
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 12,
          elevation: 2,
          pressedElevation: 4,
        ),
        rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        activeTickMarkColor: colorScheme.secondary,
        inactiveTickMarkColor: colorScheme.secondary,
        thumbColor: colorScheme.secondary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
        valueIndicatorColor: colorScheme.inverseSurface,
        valueIndicatorTextStyle: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onInverseSurface,
          fontWeight: FontWeight.bold,
        ),
        showValueIndicator: ShowValueIndicator.onDrag,
        trackHeight: 6,
      ),
      child: RangeSlider(
        values: RangeValues(currentMin, currentMax),
        min: min,
        max: max,
        divisions: max > min ? (max - min).round().clamp(1, 100) : 1,
        labels: RangeLabels(
          formatLabel?.call(currentMin) ?? '${currentMin.toStringAsFixed(0)}€',
          formatLabel?.call(currentMax) ?? '${currentMax.toStringAsFixed(0)}€',
        ),
        onChanged: onChanged,
      ),
    );
  }
}
