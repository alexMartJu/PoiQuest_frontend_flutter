import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_event_card.dart';

/// AdminEventCard: wrapper que reutiliza `AppEventCard` y pasa un
/// `overlay` con los botones en vertical en la esquina superior derecha.
class AdminEventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String startDate;
  final String? endDate;
  final String location;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminEventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.startDate,
    this.endDate,
    required this.location,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Overlay vertical con botones (se renderiza dentro de AppEventCard)
    final overlay = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          _ActionButton(icon: Icons.edit_rounded, color: colorScheme.success, onPressed: onEdit),
        if (onEdit != null && onDelete != null) const SizedBox(height: 6),
        if (onDelete != null) _ActionButton(icon: Icons.delete_rounded, color: colorScheme.error, onPressed: onDelete),
      ],
    );

    return AppEventCard(
      imageUrl: imageUrl,
      title: title,
      startDate: startDate,
      endDate: endDate,
      location: location,
      onTap: onTap,
      overlay: overlay,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({required this.icon, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
