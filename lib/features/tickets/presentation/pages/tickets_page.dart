import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_segmented_button.dart';
import 'package:poiquest_frontend_flutter/features/tickets/domain/entities/ticket.dart';
import 'package:poiquest_frontend_flutter/features/tickets/presentation/providers/tickets_providers.dart';
import 'package:poiquest_frontend_flutter/features/tickets/presentation/widgets/ticket_card.dart';

/// Página de tickets autenticados con SegmentedButton para Activos / Usados.
class TicketsPage extends ConsumerWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedTab = ref.watch(ticketsTabProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                l10n.navTickets,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Segmented Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppSegmentedButton<int>(
                segments: [
                  ButtonSegment(
                    value: 0,
                    label: Text(l10n.activeTickets),
                    icon: const Icon(Icons.confirmation_number_outlined),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text(l10n.usedTickets),
                    icon: const Icon(Icons.history),
                  ),
                ],
                selected: {selectedTab},
                onSelectionChanged: (selected) {
                  ref.read(ticketsTabProvider.notifier).state = selected.first;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Tickets list
            Expanded(
              child: selectedTab == 0
                  ? _TicketsList(
                      provider: activeTicketsProvider,
                      emptyIcon: Icons.confirmation_number_outlined,
                      emptyText: l10n.noActiveTickets,
                    )
                  : _TicketsList(
                      provider: usedTicketsProvider,
                      emptyIcon: Icons.history,
                      emptyText: l10n.noUsedTickets,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketsList extends ConsumerWidget {
  final FutureProvider<List<Ticket>> provider;
  final IconData emptyIcon;
  final String emptyText;

  const _TicketsList({
    required this.provider,
    required this.emptyIcon,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final asyncTickets = ref.watch(provider);

    return asyncTickets.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: c.error),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(provider),
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.retryButton),
              ),
            ],
          ),
        ),
      ),
      data: (tickets) {
        if (tickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(emptyIcon, size: 56, color: c.textSecondary.withValues(alpha: 0.4)),
                const SizedBox(height: 16),
                Text(
                  emptyText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: c.textSecondary,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(provider),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 24),
            itemCount: tickets.length,
            itemBuilder: (context, index) => TicketCard(ticket: tickets[index]),
          ),
        );
      },
    );
  }
}
