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
    if (EmeraldPalette.isActive(theme)) {
      return const [Color(0xFFBFE3CC), Color(0xFF4EA77D)];
    }
    if (GoldPalette.isActive(theme)) {
      return const [Color(0xFFF0D77B), Color(0xFFC9A227)];
    }
    return [theme.colorScheme.primary, theme.colorScheme.onSurfaceVariant];
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
