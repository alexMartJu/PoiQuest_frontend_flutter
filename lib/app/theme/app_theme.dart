import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_palette.dart';

class AppTheme {
  // ================== TEXT THEME ==================
  static const TextTheme _textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16, height: 1.4),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    bodySmall: TextStyle(fontSize: 12, height: 1.4),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(fontSize: 11, letterSpacing: 0.2),
  );

  // ================== COLOR SCHEME ==================
  static ColorScheme _scheme(AppPalette p, Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      secondary: p.secondary,
      onSecondary: p.onSecondary,
      surface: p.surface,
      onSurface: p.textPrimary,
      error: p.danger,
      onError: p.onDanger,

      // NEW Material 3 containers
      surfaceContainerHighest: p.surface.withValues(alpha: 0.98),
      surfaceContainerHigh: p.surface.withValues(alpha: 0.95),
      surfaceContainer: p.surface.withValues(alpha: 0.90),
      primaryContainer: p.primary.withValues(alpha: 0.15),
      onPrimaryContainer: p.onPrimary,
      secondaryContainer: p.secondary.withValues(alpha: 0.15),
      onSecondaryContainer: p.onSecondary,
      onSurfaceVariant: p.textSecondary,
      outline: p.border,
      shadow: Colors.black,
      scrim: Colors.black,
      onInverseSurface: p.textPrimary,
      inverseSurface: p.surface.withValues(alpha: 0.95),
      inversePrimary: p.primary,
    );
  }

  // ================== APP BAR THEME ==================
  static AppBarTheme _appBarTheme(ColorScheme c) {
    return AppBarTheme(
      backgroundColor: c.surfaceContainerHigh,
      foregroundColor: c.onSurface,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: c.primary),
      actionsIconTheme: IconThemeData(color: c.primary),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: c.onSurface,
      ),
    );
  }

  // ================== NAVIGATION BAR THEME ==================
  static NavigationBarThemeData _navTheme(ColorScheme c) {
    return NavigationBarThemeData(
      backgroundColor: c.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      indicatorColor: c.primary.withValues(alpha: 0.18),

      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? c.primary : c.onSurface.withValues(alpha: 0.6),
        );
      }),

      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? c.primary : c.onSurface.withValues(alpha: 0.6),
        );
      }),
    );
  }

  // ================== CHIP THEME ==================
  static ChipThemeData _chipTheme(ColorScheme c) {
    return ChipThemeData(
      backgroundColor: c.surfaceContainer.withValues(alpha: 0.6),
      selectedColor: c.primary,
      checkmarkColor: c.onPrimary,
      showCheckmark: false,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: c.onSurface,
      ),
      secondaryLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: c.onPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: c.outline.withValues(alpha: 0.6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  // ================== CARD THEME ==================
  static CardThemeData _cardTheme(ColorScheme c) {
    return CardThemeData(
      color: c.surfaceContainerHigh,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: c.outline, width: 1.4),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
    );
  }

  // ================== INPUT DECORATION THEME ==================
  static InputDecorationTheme _inputDecorationTheme(ColorScheme c) {
    return InputDecorationTheme(
      filled: true,
      fillColor: c.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  // ================== FILLED BUTTON THEME ==================
  static FilledButtonThemeData _filledButtonTheme(ColorScheme c) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        disabledBackgroundColor: c.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: c.onSurface.withValues(alpha: 0.38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ================== SNACKBAR THEME ==================
  static SnackBarThemeData _snackBarTheme(ColorScheme c) {
    return SnackBarThemeData(
      backgroundColor: c.inverseSurface,
      contentTextStyle: TextStyle(
        color: c.onInverseSurface,
        fontSize: 14,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ================== FINAL THEMES ==================
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _scheme(appPaletteLight, Brightness.light),
    textTheme: _textTheme,
    scaffoldBackgroundColor: appPaletteLight.background,
    cardColor: appPaletteLight.surface,
    appBarTheme: _appBarTheme(_scheme(appPaletteLight, Brightness.light)),
    navigationBarTheme: _navTheme(_scheme(appPaletteLight, Brightness.light)),
    chipTheme: _chipTheme(_scheme(appPaletteLight, Brightness.light)),
    cardTheme: _cardTheme(_scheme(appPaletteLight, Brightness.light)),
    inputDecorationTheme: _inputDecorationTheme(_scheme(appPaletteLight, Brightness.light)),
    filledButtonTheme: _filledButtonTheme(_scheme(appPaletteLight, Brightness.light)),
    snackBarTheme: _snackBarTheme(_scheme(appPaletteLight, Brightness.light)),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _scheme(appPaletteDark, Brightness.dark),
    textTheme: _textTheme,
    scaffoldBackgroundColor: appPaletteDark.background,
    cardColor: appPaletteDark.surface,
    appBarTheme: _appBarTheme(_scheme(appPaletteDark, Brightness.dark)),
    navigationBarTheme: _navTheme(_scheme(appPaletteDark, Brightness.dark)),
    chipTheme: _chipTheme(_scheme(appPaletteDark, Brightness.dark)),
    cardTheme: _cardTheme(_scheme(appPaletteDark, Brightness.dark)),
    inputDecorationTheme: _inputDecorationTheme(_scheme(appPaletteDark, Brightness.dark)),
    filledButtonTheme: _filledButtonTheme(_scheme(appPaletteDark, Brightness.dark)),
    snackBarTheme: _snackBarTheme(_scheme(appPaletteDark, Brightness.dark)),
  );
}

// ================== TOKENS ==================
extension AppColorTokens on ColorScheme {
  Color get success =>
      brightness == Brightness.dark ? appPaletteDark.secondary : appPaletteLight.secondary;

  Color get onSuccess =>
      brightness == Brightness.dark ? appPaletteDark.onPrimary : appPaletteLight.onPrimary;

  Color get warning =>
      brightness == Brightness.dark ? appPaletteDark.warning : appPaletteLight.warning;

  Color get onWarning =>
      brightness == Brightness.dark ? appPaletteDark.onWarning : appPaletteLight.onWarning;

  Color get border =>
      brightness == Brightness.dark ? appPaletteDark.border : appPaletteLight.border;

  Color get textPrimary =>
      brightness == Brightness.dark ? appPaletteDark.textPrimary : appPaletteLight.textPrimary;

  Color get textSecondary =>
      brightness == Brightness.dark ? appPaletteDark.textSecondary : appPaletteLight.textSecondary;

  Color get titles =>
      brightness == Brightness.dark ? appPaletteDark.primary : appPaletteLight.primary;
}
