import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_no_auth_prompt.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Página de tickets para usuarios no autenticados.
/// 
/// Muestra un mensaje invitando al usuario a iniciar sesión.
class TicketsPageNoAuth extends StatelessWidget {
  const TicketsPageNoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return AppNoAuthPrompt(
      icon: Icons.confirmation_number_outlined,
      title: t.signInToViewTickets,
      description: t.signInToViewTicketsDesc,
    );
  }
}
