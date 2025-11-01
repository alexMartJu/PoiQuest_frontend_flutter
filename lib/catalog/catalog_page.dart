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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.titleCatalog),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: t.preferences,
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
            title: Text(t.buttonsDemo),
            subtitle: Text(t.buttonsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ButtonsDemo()),
              );
            },
          ),

          ListTile(
            title: Text(t.badgesDemo),
            subtitle: Text(t.badgesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BadgesDemo()),
              );
            },
          ),

          ListTile(
            title: Text(t.filterChipsDemo),
            subtitle: Text(t.filterChipsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FilterChipsDemo()),
              );
            },
          ),

          ListTile(
            title: Text(t.navigationDemo),
            subtitle: Text(t.navigationDemoSubtitle),
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
