import 'package:flutter/material.dart';

ThemeData getThemeData({
  required bool isDarkMode,
  bool isAmoled = false,
}) {
  // AMOLED only applies when dark mode is enabled
  final shouldApplyAmoled = isDarkMode && isAmoled;

  const white = Colors.white;
  const black = Colors.black;

  final colorScheme = ColorScheme(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primary: isDarkMode ? white : black,
    onPrimary: isDarkMode ? black : white,
    primaryContainer: isDarkMode ? black : white,
    onPrimaryContainer: isDarkMode ? white : black,
    secondary: isDarkMode ? white : black,
    onSecondary: isDarkMode ? black : white,
    secondaryContainer: isDarkMode
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF2F2F2),
    onSecondaryContainer: isDarkMode ? white : black,
    tertiary: isDarkMode ? white : black,
    onTertiary: isDarkMode ? black : white,
    tertiaryContainer: isDarkMode
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF2F2F2),
    onTertiaryContainer: isDarkMode ? white : black,
    error: const Color(0xFF9E9E9E),
    onError: isDarkMode ? black : white,
    errorContainer: isDarkMode
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF2F2F2),
    onErrorContainer: isDarkMode ? white : black,
    surface: shouldApplyAmoled ? black : (isDarkMode ? black : white),
    onSurface: isDarkMode ? white : black,
    surfaceContainerHighest: isDarkMode
        ? const Color(0xFF242424)
        : const Color(0xFFEDEDED),
    surfaceContainerHigh: isDarkMode
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF2F2F2),
    surfaceContainer: isDarkMode
        ? const Color(0xFF181818)
        : const Color(0xFFF7F7F7),
    surfaceContainerLow: isDarkMode
        ? const Color(0xFF141414)
        : const Color(0xFFFAFAFA),
    surfaceContainerLowest: isDarkMode
        ? const Color(0xFF0F0F0F)
        : const Color(0xFFFFFFFF),
    onSurfaceVariant: isDarkMode
        ? const Color(0xFFB3B3B3)
        : const Color(0xFF4D4D4D),
    outline: isDarkMode ? const Color(0xFF8C8C8C) : const Color(0xFF333333),
    outlineVariant: isDarkMode
        ? const Color(0xFF2E2E2E)
        : const Color(0xFFE0E0E0),
    shadow: black,
    scrim: black,
    inverseSurface: isDarkMode ? white : black,
    onInverseSurface: isDarkMode ? black : white,
    inversePrimary: isDarkMode ? black : white,
    surfaceTint: Colors.transparent,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        // Set the predictive back transitions for Android.
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: shouldApplyAmoled
        ? black
        : colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: shouldApplyAmoled ? black : colorScheme.surface,
      foregroundColor: isDarkMode ? white : black,
    ),
    fontFamily: 'Poppins',
  );
}
