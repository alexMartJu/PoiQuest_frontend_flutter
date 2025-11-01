import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/buttons_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/badges_demo.dart';
import 'package:poiquest_frontend_flutter/features/preferences/presentation/pages/preferences_page.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/navigation_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/filter_chips_demo.dart';


class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.titleCatalog),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.preferences,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PreferencesPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.buttonsDemo),
            subtitle: Text(AppLocalizations.of(context)!.buttonsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ButtonsDemo()));
            },
          ),

          ListTile(
            title: Text(AppLocalizations.of(context)!.badgesDemo),
            subtitle: Text(AppLocalizations.of(context)!.badgesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BadgesDemo()),
              );
            },
          ),

          ListTile(
            title: Text(AppLocalizations.of(context)!.filterChipsDemo),
            subtitle: Text(AppLocalizations.of(context)!.filterChipsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FilterChipsDemo()),
            ),
          ),

          ListTile(
            title: const Text('Navigation Demo'),
            subtitle: const Text('AppBar + NavigationBar'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NavigationDemo()),
              );
            },
          ),

        ],
      ),
    );
  }
}
