import 'package:flutter/material.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onSelected;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return FilterChip(
      selected: selected,
      onSelected: (_) => onSelected?.call(),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: selected ? c.onPrimary : c.onSurface.withValues(alpha: 0.8),
        ),
      ),
      selectedColor: c.primary,
      backgroundColor: c.surfaceContainer.withValues(alpha: 0.6),
      checkmarkColor: c.onPrimary,
      showCheckmark: false,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected
              ? Colors.transparent
              : c.outline.withValues(alpha: 0.6),
        ),
      ),
    );

  }
}
