import 'package:flutter/material.dart';
import 'package:vit_ap_student_app/core/theme/app_theme.dart';

/// The standard card used across the app.
///
/// In the emerald and gold themes it renders the directional "specular
/// edge": a thin gradient border that is brightest around the top-left
/// corner and fades along the perimeter — like light reflecting off the
/// edge of a physical object. Every other theme renders the classic flat
/// card with a hairline border.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 18,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final emerald = EmeraldPalette.isActive(theme);
    final gold = GoldPalette.isActive(theme);

    if (!emerald && !gold) {
      return Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: 0.75,
          ),
        ),
        child: child,
      );
    }

    final Color edgeBright;
    final Color edgeMid;
    final Color edgeDark;
    final Color cardColor;
    if (emerald) {
      edgeBright = EmeraldPalette.edgeBright;
      edgeMid = EmeraldPalette.edgeMid;
      edgeDark = EmeraldPalette.edgeDark;
      cardColor = EmeraldPalette.card;
    } else {
      edgeBright = GoldPalette.edgeBright;
      edgeMid = GoldPalette.edgeMid;
      edgeDark = GoldPalette.edgeDark;
      cardColor = GoldPalette.card;
    }

    // Specular edge: gradient ring (bright top-left -> invisible
    // bottom-right) with the card surface inset by the ring's thickness.
    const edgeThickness = 1.1;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [edgeBright, edgeMid, edgeDark],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      padding: const EdgeInsets.all(edgeThickness),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(borderRadius - edgeThickness),
        ),
        child: padding == null
            ? child
            : Padding(padding: padding!, child: child),
      ),
    );
  }
}
