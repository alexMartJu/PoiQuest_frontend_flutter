import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.titleCatalog), centerTitle: true),
      body: ListView(
        children: [
          ListTile(
            title: Text(t.buttonsDemo),
            subtitle: Text(t.buttonsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/catalog/buttons'),
          ),
          ListTile(
            title: Text(t.badgesDemo),
            subtitle: Text(t.badgesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/catalog/badges'),
          ),
          ListTile(
            title: Text(t.cardsDemo),
            subtitle: Text(t.cardsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/catalog/cards'),
          ),
          ListTile(
            title: Text(t.filterChipsDemo),
            subtitle: Text(t.filterChipsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/catalog/filters'),
          ),
          ListTile(
            title: Text(t.navigationDemo),
            subtitle: Text(t.navigationDemoSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/catalog/navigation'),
          ),
          ListTile(
            title: Text(t.textFieldsDemo),
            subtitle: Text(t.textFieldsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/catalog/textfields'),
          ),
        ],
      ),
    );
  }
}
