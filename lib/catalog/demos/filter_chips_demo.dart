import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filter_chip.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class FilterChipsDemo extends StatefulWidget {
  const FilterChipsDemo({super.key});

  @override
  State<FilterChipsDemo> createState() => _FilterChipsDemoState();
}

class _FilterChipsDemoState extends State<FilterChipsDemo> {
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final filters = [
      l.filterAll,
      l.filterMusic,
      l.filterArt,
      l.filterSports,
    ];

    // Default on first build
    selectedFilter = selectedFilter.isEmpty ? filters.first : selectedFilter;

    return ShowcaseScaffold(
      title: l.filterChipsDemo,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.filterChipsTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: filters.map((label) {
              return AppFilterChip(
                label: label,
                selected: selectedFilter == label,
                onSelected: () => setState(() => selectedFilter = label),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
