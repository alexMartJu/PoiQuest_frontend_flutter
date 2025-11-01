import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_badge.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class BadgesDemo extends StatelessWidget {
  const BadgesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return ShowcaseScaffold(
      title: l.badgesDemo,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.statusTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppBadge(label: l.active, variant: AppBadgeVariant.status),
            ],
          ),

          const SizedBox(height: 24),

          Text(l.rewardTitle),
          const SizedBox(height: 8),
          // ignore: prefer_const_constructors
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              AppBadge(label: '+150', variant: AppBadgeVariant.reward),
            ],
          ),

          const SizedBox(height: 24),

          Text(l.infoTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppBadge(label: l.points(200), variant: AppBadgeVariant.info),
            ],
          ),

          const SizedBox(height: 24),

          Text(l.categoryTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppBadge(label: l.reviews, variant: AppBadgeVariant.category),
            ],
          ),
        ],
      ),
    );
  }
}
