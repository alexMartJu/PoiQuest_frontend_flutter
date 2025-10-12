import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_palette.dart';

class AppTheme {
  static final TextTheme _textTheme = const TextTheme(
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

  // Tema claro
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: appPaletteLight.background,
    colorScheme: ColorScheme.light(
      primary: appPaletteLight.primary,
      onPrimary: appPaletteLight.onPrimary,
      secondary: appPaletteLight.secondary,
      onSecondary: appPaletteLight.onSecondary,
      error: appPaletteLight.danger,
      onError: appPaletteLight.onDanger,
      surface: appPaletteLight.surface,
    ),
    cardColor: appPaletteLight.surface,
    dividerColor: appPaletteLight.border,
    textTheme: _textTheme.apply(
      bodyColor: appPaletteLight.textPrimary,
      displayColor: appPaletteLight.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: appPaletteLight.surface,
      foregroundColor: appPaletteLight.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: appPaletteLight.surface,
      selectedItemColor: appPaletteLight.primary,
      unselectedItemColor: appPaletteLight.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: appPaletteLight.secondary,
      foregroundColor: appPaletteLight.onSecondary,
    ),
  );

  // Tema oscuro
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: appPaletteDark.background,
    colorScheme: ColorScheme.dark(
      primary: appPaletteDark.primary,
      onPrimary: appPaletteDark.onPrimary,
      secondary: appPaletteDark.secondary,
      onSecondary: appPaletteDark.onSecondary,
      error: appPaletteDark.danger,
      onError: appPaletteDark.onDanger,
      surface: appPaletteDark.surface,
    ),
    cardColor: appPaletteDark.surface,
    dividerColor: appPaletteDark.border,
    textTheme: _textTheme.apply(
      bodyColor: appPaletteDark.textPrimary,
      displayColor: appPaletteDark.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: appPaletteDark.surface,
      foregroundColor: appPaletteDark.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: appPaletteDark.surface,
      selectedItemColor: appPaletteDark.primary,
      unselectedItemColor: appPaletteDark.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: appPaletteDark.secondary,
      foregroundColor: appPaletteDark.onSecondary,
    ),
  );
}



