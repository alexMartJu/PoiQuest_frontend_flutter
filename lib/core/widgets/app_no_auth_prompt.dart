import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Widget reutilizable que muestra un mensaje para usuarios no autenticados.
/// 
/// Invita al usuario a iniciar sesión con un icono, título, descripción
/// y botón de acción personalizables.
class AppNoAuthPrompt extends StatelessWidget {
  /// Icono que se muestra en el círculo superior.
  final IconData icon;
  
  /// Título principal del mensaje.
  final String title;
  
  /// Descripción detallada debajo del título.
  final String description;
  
  /// Texto opcional del pie de página.
  /// 
  /// Por defecto: "You can still explore events and POIs without signing in"
  final String? footerText;

  const AppNoAuthPrompt({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              
              // Título
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Descripción
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Botón de Sign In / Register
              AppFilledButton(
                label: t.signInRegister,
                icon: Icons.login,
                onPressed: () {
                  context.push('/auth/login');
                },
              ),
              const SizedBox(height: 16),
              
              // Texto adicional
              Text(
                footerText ?? t.exploreWithoutSignIn,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
