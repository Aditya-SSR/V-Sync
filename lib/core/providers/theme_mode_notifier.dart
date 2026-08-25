import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vit_ap_student_app/core/providers/color_theme_notifier.dart';
import 'package:vit_ap_student_app/core/providers/user_preferences_notifier.dart';
import 'package:vit_ap_student_app/core/theme/app_theme.dart';

part 'theme_mode_notifier.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeData build() {
    // Get user preferences to determine initial theme
    final userPreferences = ref.read(userPreferencesProvider);
    final colorTheme = ref.watch(colorThemeProvider);

    return getThemeData(
      isDarkMode: userPreferences.isDarkModeEnabled,
      isAmoled: userPreferences.isAmoledEnabled,
      colorTheme: colorTheme,
    );
  }

  Future<void> toggleTheme() async {
    final currentPreferences = ref.read(userPreferencesProvider);
    final newThemeMode = !currentPreferences.isDarkModeEnabled;

    final updatedPreferences = currentPreferences.copyWith(
      isDarkModeEnabled: newThemeMode,
    );
    await ref
        .read(userPreferencesProvider.notifier)
        .updatePreferences(updatedPreferences);

    // Rebuild MaterialApp theme.
    ref.invalidateSelf();
    // Gold is dark-mode-only: re-sync the launcher icon for the new mode.
    ref.read(colorThemeProvider.notifier).syncLauncherIcon();
  }

  Future<void> toggleAmoled() async {
    final currentPreferences = ref.read(userPreferencesProvider);
    final newAmoledMode = !currentPreferences.isAmoledEnabled;

    final updatedPreferences = currentPreferences.copyWith(
      isAmoledEnabled: newAmoledMode,
    );
    await ref
        .read(userPreferencesProvider.notifier)
        .updatePreferences(updatedPreferences);

    // Rebuild theme with new AMOLED mode
    ref.invalidateSelf();
  }
}
