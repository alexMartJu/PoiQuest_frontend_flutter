import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_no_auth_prompt.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Página de exploración para usuarios no autenticados.
///
/// Muestra un mensaje invitando al usuario a iniciar sesión.
class ExplorePageNoAuth extends StatelessWidget {
  const ExplorePageNoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AppNoAuthPrompt(
      icon: Icons.explore_outlined,
      title: t.signInToExplore,
      description: t.signInToExploreDesc,
    );
  }
}
