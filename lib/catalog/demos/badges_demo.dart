import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_badge.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class BadgesDemo extends StatefulWidget {
  const BadgesDemo({super.key});

  @override
  State<BadgesDemo> createState() => _BadgesDemoState();
}

class _BadgesDemoState extends State<BadgesDemo> {
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    final filters = [
      AppLocalizations.of(context)!.filterAll,
      AppLocalizations.of(context)!.filterMusic,
      AppLocalizations.of(context)!.filterArt,
      AppLocalizations.of(context)!.filterSports,
    ];

    if (selectedFilter.isEmpty) {
      selectedFilter = filters.first;
    }

    return ShowcaseScaffold(
      title: AppLocalizations.of(context)!.badgesDemo,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filtros
          Text(AppLocalizations.of(context)!.badgesFilterTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: filters.map((label) {
              return AppBadge(
                label: label,
                variant: AppBadgeVariant.filter,
                selected: selectedFilter == label,
                onTap: () => setState(() => selectedFilter = label),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Estado
          Text(AppLocalizations.of(context)!.statusTitle),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: AppLocalizations.of(context)!.active,
              variant: AppBadgeVariant.status,
            ),
          ),

          const SizedBox(height: 24),

          // Recompensa
          Text(AppLocalizations.of(context)!.rewardTitle),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: '+150',
              variant: AppBadgeVariant.reward,
            ),
          ),

          const SizedBox(height: 24),

          // Información
          Text(AppLocalizations.of(context)!.infoTitle),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: AppLocalizations.of(context)!.points(200),
              variant: AppBadgeVariant.info,
            ),
          ),

          const SizedBox(height: 24),

          // Categoría
          Text(AppLocalizations.of(context)!.categoryTitle),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: AppLocalizations.of(context)!.reviews,
              variant: AppBadgeVariant.category,
            ),
          ),
        ],
      ),
    );
  }
}
