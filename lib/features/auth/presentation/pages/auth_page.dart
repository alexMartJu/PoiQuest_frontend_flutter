import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/widgets/login_form.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/widgets/register_form.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Página de autenticación con pestañas estilo pill (según imagen de referencia).
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Close button header (la interfaz empieza debajo de esta cruz)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),

            // Logo centrado justo debajo de la cruz
              // Logo: pill encima y texto 'PoiQuest' debajo (como pediste)
              Center(
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          Icon(
                            Icons.location_on_outlined,
                            color: theme.colorScheme.onPrimary,
                            size: 48,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700) ?? const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                          children: [
                            TextSpan(text: 'Poi', style: TextStyle(color: theme.colorScheme.secondary)),
                            TextSpan(text: 'Quest', style: TextStyle(color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

            // Subtítulo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                t.signInToContinue,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Contenedor de tabs (estilo pill)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // pequeño inset para que el indicador encaje en el contenedor sin quedar grueso
                  indicatorPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  // labels compactos
                  labelPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  indicator: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withAlpha((0.06 * 255).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: theme.colorScheme.onSurface,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: t.login),
                    Tab(text: t.register),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Contenido de las pestañas
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  LoginForm(),
                  RegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

