import 'package:flutter/material.dart';
import 'package:vit_ap_student_app/core/theme/app_theme.dart';

/// A heading rendered with the active accent theme's gradient instead of
/// a flat color. Falls back to a subtle primary->muted gradient in the
/// monochrome theme.
class AccentGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AccentGradientText(this.text, {super.key, this.style});

  static List<Color> gradientFor(ThemeData theme) {
    final cs = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    if (dark && EmeraldPalette.isActive(theme)) {
      return const [Color(0xFFBFE3CC), Color(0xFF4EA77D)];
    }
    if (dark && GoldPalette.isActive(theme)) {
      return const [Color(0xFFF0D77B), Color(0xFFC9A227)];
    }
    if (dark && RedPalette.isActive(theme)) {
      return const [Color(0xFFF0A8A8), Color(0xFFE05252)];
    }
    // Light accent themes.
    if (cs.tertiary == const Color(0xFFB08D26)) {
      return const [Color(0xFFD4AF37), Color(0xFF8A6D1D)];
    }
    if (cs.tertiary == const Color(0xFFC2185B)) {
      return const [Color(0xFFF48FB1), Color(0xFFC2185B)];
    }
    if (cs.tertiary == const Color(0xFFC62828)) {
      return const [Color(0xFFEF5350), Color(0xFFB71C1C)];
    }
    return [cs.primary, cs.onSurfaceVariant];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = gradientFor(theme);

    return ShaderMask(
      shaderCallback: (bounds) =>
          LinearGradient(colors: colors).createShader(bounds),
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
      ),
    );
  }
}
