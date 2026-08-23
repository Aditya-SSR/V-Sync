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
    textTheme: _buildTextTheme(
      onSurface: isDarkMode ? white : black,
      onSurfaceVariant: isDarkMode
          ? const Color(0xFFB3B3B3)
          : const Color(0xFF4D4D4D),
    ),
    primaryTextTheme: _buildTextTheme(
      onSurface: isDarkMode ? white : black,
      onSurfaceVariant: isDarkMode
          ? const Color(0xFFB3B3B3)
          : const Color(0xFF4D4D4D),
    ),
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
    fontFamily: 'Outfit',
  );
}

// Outfit carries the identity of the app (headings, titles, body).
// Inter handles the fine print: captions, timestamps, labels and metadata.
//
// Weight pairing guide:
//   Headings  -> Outfit SemiBold (600) for a crisp, confident look
//   Titles    -> Outfit Medium (500) to stay prominent without shouting
//   Body      -> Outfit Regular (400)
//   Buttons   -> Outfit Medium (500), slightly tracked out
//   Details   -> Inter Regular/Medium (400/500), slightly tighter spacing
TextTheme _buildTextTheme({
  required Color onSurface,
  required Color onSurfaceVariant,
}) {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: onSurface,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: onSurface,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      color: onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
      color: onSurface,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: onSurface,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      color: onSurface,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: onSurfaceVariant,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: 0.4,
      color: onSurfaceVariant,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      letterSpacing: 0.4,
      color: onSurfaceVariant,
    ),
  );
}
