import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_badge.dart';

class BadgesDemo extends StatefulWidget {
  const BadgesDemo({super.key});

  @override
  State<BadgesDemo> createState() => _BadgesDemoState();
}

class _BadgesDemoState extends State<BadgesDemo> {
  String selectedFilter = 'Todos';
  final filters = ['Todos', 'Musica', 'Arte', 'Deportes'];

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Badges',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filtros
          const Text('Badges de filtro'),
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
          const Text('Estado'),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: 'Activo',
              variant: AppBadgeVariant.status,
            ),
          ),

          const SizedBox(height: 24),

          // Recompensa
          const Text('Recompensa'),
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
          const Text('Info'),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: '200 puntos',
              variant: AppBadgeVariant.info,
            ),
          ),

          const SizedBox(height: 24),

          // Categoría
          const Text('Categoría'),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: AppBadge(
              label: 'Reviews',
              variant: AppBadgeVariant.category,
            ),
          ),
        ],
      ),
    );
  }
}
