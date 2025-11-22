import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/app/router.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/features/preferences/presentation/providers/preferences_providers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa el provider de preferencias (es un AsyncValue<Preferences>)
    final prefsAsync = ref.watch(preferencesProvider);

    // Usamos maybeWhen para obtener el valor del modo oscuro
    final darkMode = prefsAsync.maybeWhen(
      data: (p) => p.darkmode,
      orElse: () => false,
    );

    final language = prefsAsync.maybeWhen(
      data: (p) => p.language,
      orElse: () => 'es',
    );

    // Observa el router provider para que reaccione a cambios de autenticación
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,

      // i18n config
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      locale: Locale(language),
    );
  }
}
