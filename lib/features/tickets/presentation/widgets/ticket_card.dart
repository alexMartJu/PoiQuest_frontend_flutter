import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/utils/date_utils.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_badge.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket_status.dart';

/// Tarjeta de ticket con diseño de cabecera oscura, badge de estado y QR.
class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: c.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dark header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            color: c.titles,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket.eventName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: c.onPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppBadge(
                      label: _statusLabel(ticket.status, l10n),
                      variant: _statusVariant(ticket.status),
                    ),
                  ],
                ),
                if (ticket.isFreeEvent) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.freeEventLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: c.onPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Body blanco
          Container(
            color: c.surface,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info rows
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: formatDateLongFromIsoWithContext(context, ticket.visitDate),
                        color: c.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      if (ticket.eventCity != null) ...[
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          text: ticket.eventCity!,
                          color: c.textSecondary,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),

                // QR code
                if (ticket.qrCode != null && ticket.qrCode!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: QrImageView(
                      data: ticket.qrCode!,
                      version: QrVersions.auto,
                      size: 140,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.circle,
                        color: Color(0xFF111827),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _statusLabel(TicketStatus status, AppLocalizations l10n) {
    return switch (status) {
      TicketStatus.active => l10n.ticketStatusActive,
      TicketStatus.used => l10n.ticketStatusUsed,
      TicketStatus.expired => l10n.ticketStatusExpired,
      TicketStatus.pendingPayment => l10n.ticketStatusPending,
    };
  }

  static AppBadgeVariant _statusVariant(TicketStatus status) {
    return switch (status) {
      TicketStatus.active => AppBadgeVariant.status,
      TicketStatus.used => AppBadgeVariant.neutral,
      TicketStatus.expired => AppBadgeVariant.danger,
      TicketStatus.pendingPayment => AppBadgeVariant.reward,
    };
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
