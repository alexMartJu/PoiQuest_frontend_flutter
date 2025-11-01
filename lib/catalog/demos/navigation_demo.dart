import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_app_bar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_navigation_bar.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class NavigationDemo extends StatefulWidget {
  const NavigationDemo({super.key});

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ShowcaseScaffold(
      title: t.navigationDemo,
      body: Scaffold(
        appBar: const AppAppBar(),
        bottomNavigationBar: AppNavigationBar(
          currentIndex: selectedIndex,
          onTap: (i) => setState(() => selectedIndex = i),
        ),
        body: Center(
          child: Text(
            t.currentTab(selectedIndex),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
