import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/buttons_demo.dart';
import 'package:poiquest_frontend_flutter/catalog/demos/badges_demo.dart';
import 'package:poiquest_frontend_flutter/features/preferences/presentation/pages/preferences_page.dart';


class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Componentes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Preferencias',
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
            title: const Text('Botones'),
            subtitle: const Text('Variantes, estados y tamaños'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ButtonsDemo()));
            },
          ),

          ListTile(
            title: const Text('Badges'),
            subtitle: const Text('Filtros, estados y categorías'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BadgesDemo()),
              );
            },
          ),
        ],
      ),
    );
  }
}
