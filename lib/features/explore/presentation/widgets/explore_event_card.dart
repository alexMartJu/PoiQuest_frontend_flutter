import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_event_card.dart';
import 'package:poiquest_frontend_flutter/features/explore/domain/entities/explore_event.dart';

/// Card de evento para la sección Explore.
///
/// Reutiliza [AppEventCard] como base (imagen, título, fechas, ubicación)
/// y añade un overlay circular con el progreso de POIs escaneados sobre el total.
///
/// Al pulsar navega a `/explore/events/{uuid}/progress` pasando `visitDate`,
/// `ticketUuid` y `ticketStatus` como extras para que la pantalla de detalle
/// pueda determinar el nivel de acceso.
class ExploreEventCard extends StatelessWidget {
  final ExploreEvent event;

  const ExploreEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // Calcular fracción de progreso (0.0 a 1.0) para el indicador circular.
    final progress = event.totalPois > 0
        ? event.scannedPois / event.totalPois
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: AppEventCard(
        imageUrl: event.primaryImageUrl ?? '',
        title: event.eventName,
        startDate: event.startDate,
        endDate: event.endDate,
        location: event.cityName ?? l10n.noLocation,
        onTap: () {
          context.push(
            '/explore/events/${event.eventUuid}/progress',
            extra: {
              'visitDate': event.visitDate,
              'ticketUuid': event.ticketUuid,
              'ticketStatus': event.ticketStatus,
            },
          );
        },
        overlay: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: c.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.5,
                  backgroundColor: c.outline.withValues(alpha: 0.2),
                  color: progress >= 1.0 ? c.secondary : c.primary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${event.scannedPois}/${event.totalPois}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: c.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
