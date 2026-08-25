import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/core/providers/theme_mode_notifier.dart';
import 'package:vit_ap_student_app/core/providers/user_preferences_notifier.dart';
import 'package:vit_ap_student_app/core/theme/app_theme.dart';

final colorThemeProvider =
    NotifierProvider<ColorThemeNotifier, String>(ColorThemeNotifier.new);

/// Persists the selected accent theme ('mono' | 'gold') and keeps the
/// Android launcher icon in sync with it. Gold is dark-mode-only: the
/// effective theme in light mode is always monochrome.
class ColorThemeNotifier extends Notifier<String> {
  static const _key = 'color_theme';
  static const _appliedKey = 'launcher_icon_applied';
  static const _channel = MethodChannel('vsync/launcher_icon');

  @override
  String build() {
    _load();
    return AppColorTheme.mono;
  }

  /// The theme that is actually in effect right now (gold only exists
  /// in dark mode).
  String get effectiveTheme {
    final dark = ref.read(userPreferencesProvider).isDarkModeEnabled;
    if (state == AppColorTheme.gold && !dark) return AppColorTheme.mono;
    return state;
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getString(_key) ?? AppColorTheme.mono;
      await syncLauncherIcon();
    } catch (_) {
      state = AppColorTheme.mono;
    }
  }

  Future<void> setTheme(String theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, theme);
    await syncLauncherIcon();
    // Rebuild MaterialApp theme.
    ref.invalidate(themeModeProvider);
  }

  /// Re-applies the launcher icon for the current effective theme.
  /// Called after dark-mode toggles too, since gold is dark-only.
  Future<void> syncLauncherIcon() async {
    final prefs = await SharedPreferences.getInstance();
    final effective = effectiveTheme;
    final applied = prefs.getString(_appliedKey);
    if (applied == effective) return; // already in sync

    try {
      await _channel.invokeMethod(
        'setGold',
        {'gold': effective == AppColorTheme.gold},
      );
      await prefs.setString(_appliedKey, effective);
    } catch (_) {
      // Native side unavailable — ignore.
    }
  }
}
