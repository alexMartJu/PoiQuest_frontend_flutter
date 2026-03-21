import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/utils/date_utils.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_badge.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/events/presentation/providers/events_providers.dart';

/// Pantalla de detalle de un evento. Muestra imagen hero, badges, info,
/// organizador, sponsor, lista de POIs/rutas y galería de imágenes.
class EventDetailPage extends ConsumerWidget {
  final String uuid;

  const EventDetailPage({super.key, required this.uuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEvent = ref.watch(eventDetailProvider(uuid));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: asyncEvent.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorBody(
          message: l10n.errorLoadingDetail,
          onRetry: () => ref.invalidate(eventDetailProvider(uuid)),
          l10n: l10n,
        ),
        data: (event) => _EventDetailBody(event: event),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorBody({
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: c.error),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retryButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventDetailBody extends StatelessWidget {
  final Event event;

  const _EventDetailBody({required this.event});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        // Hero image with back button
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          leading: const _CircularBackButton(),
          flexibleSpace: FlexibleSpaceBar(
            background: event.primaryImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: event.primaryImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: c.border),
                    errorWidget: (_, __, ___) => Container(
                      color: c.border,
                      child: Icon(Icons.image_not_supported, color: c.textSecondary, size: 48),
                    ),
                  )
                : Container(
                    color: c.border,
                    child: Icon(Icons.event, color: c.textSecondary, size: 64),
                  ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges row (category + premium)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (event.category != null)
                      AppBadge(label: event.category!.name, variant: AppBadgeVariant.primary),
                    if (event.isPremium)
                      AppBadge(label: l10n.premiumEvent, variant: AppBadgeVariant.reward),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  event.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Date & Location
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: _formatDateRange(context, event),
                ),
                if (event.cityName != null) ...[
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: event.cityName!,
                  ),
                ],

                // Price
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Icons.sell_outlined,
                  text: event.price != null && event.price! > 0
                      ? '${event.price!.toStringAsFixed(2)} €'
                      : l10n.freeEvent,
                ),

                // Description
                if (event.description != null && event.description!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.descriptionLabel),
                  const SizedBox(height: 8),
                  Text(
                    event.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: c.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],

                // Organizer
                if (event.organizer != null) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.organizerLabel),
                  const SizedBox(height: 8),
                  _OrganizerCard(
                    name: event.organizer!.name,
                    imageUrl: event.organizer!.primaryImageUrl,
                  ),
                ],

                // Sponsor
                if (event.sponsor != null) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.sponsorLabel),
                  const SizedBox(height: 8),
                  _OrganizerCard(
                    name: event.sponsor!.name,
                    imageUrl: event.sponsor!.primaryImageUrl,
                  ),
                ],

                // Points of Interest
                if (event.pointsOfInterest != null && event.pointsOfInterest!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.pointsOfInterestLabel),
                  const SizedBox(height: 8),
                  ...event.pointsOfInterest!.map(
                    (poi) => _TappableListTile(
                      icon: Icons.place_outlined,
                      title: poi.title,
                      onTap: () => context.push('/points-of-interest/${poi.uuid}'),
                    ),
                  ),
                ],

                // Routes
                if (event.routes != null && event.routes!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.routesLabel),
                  const SizedBox(height: 8),
                  ...event.routes!.map(
                    (route) => _TappableListTile(
                      icon: Icons.route_outlined,
                      title: route.name,
                      onTap: () => context.push('/routes/${route.uuid}'),
                    ),
                  ),
                ],

                // Image gallery
                if (event.images.length > 1) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: l10n.imagesLabel),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: event.images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final img = event.images[index];
                        return GestureDetector(
                          onTap: () => _openImageViewer(
                            context,
                            event.images.map((e) => e.imageUrl).toList(),
                            index,
                          ),
                          // Hero tag compartido con _ImageViewerOverlay para animar la transición
                          child: Hero(
                            tag: 'event_image_$index',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: img.imageUrl,
                                width: 240,
                                height: 180,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  width: 240,
                                  height: 180,
                                  color: c.border,
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  width: 240,
                                  height: 180,
                                  color: c.border,
                                  child: Icon(Icons.broken_image, color: c.textSecondary),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Abre un visor de imágenes a pantalla completa con transición Hero.
  void _openImageViewer(BuildContext context, List<String> imageUrls, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return _ImageViewerOverlay(
            imageUrls: imageUrls,
            initialIndex: initialIndex,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  String _formatDateRange(BuildContext context, Event event) {
    final start = formatDateLongFromIsoWithContext(context, event.startDate);
    if (event.endDate != null) {
      final end = formatDateLongFromIsoWithContext(context, event.endDate!);
      return '$start — $end';
    }
    return start;
  }
}

/// Overlay fullscreen con PageView para navegar entre imágenes,
/// InteractiveViewer para pinch-to-zoom y Hero para la transición animada.
class _ImageViewerOverlay extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _ImageViewerOverlay({required this.imageUrls, required this.initialIndex});

  @override
  State<_ImageViewerOverlay> createState() => _ImageViewerOverlayState();
}

class _ImageViewerOverlayState extends State<_ImageViewerOverlay> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dismiss on tap background
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
          // Image PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final url = widget.imageUrls[index];
              return Center(
                child: Hero(
                  tag: 'event_image_$index',
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        color: Colors.white54,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.close),
            ),
          ),
          // Counter
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.imageUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircularBackButton extends StatelessWidget {
  const _CircularBackButton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: c.surface.withValues(alpha: 0.85),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: c.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
    );
  }
}

class _OrganizerCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  const _OrganizerCard({required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.business, size: 20, color: c.textSecondary),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: c.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TappableListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _TappableListTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: c.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: c.textPrimary,
                        ),
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: c.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
