import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_no_auth_prompt.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Página de scan QR para usuarios no autenticados.
/// 
/// Muestra un mensaje invitando al usuario a iniciar sesión.
class ScanPageNoAuth extends StatelessWidget {
  const ScanPageNoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return AppNoAuthPrompt(
      icon: Icons.qr_code_scanner,
      title: t.signInToScanQR,
      description: t.signInToScanQRDesc,
    );
  }
}
