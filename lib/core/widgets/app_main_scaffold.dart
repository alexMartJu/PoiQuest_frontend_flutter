import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_app_bar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_navigation_bar.dart';

class AppMainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppMainScaffold({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        onSettingsTap: () => context.push('/preferences'),
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
      body: navigationShell,
    );
  }
}
