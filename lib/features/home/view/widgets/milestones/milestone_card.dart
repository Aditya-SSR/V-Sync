import 'package:flutter/material.dart';
import 'package:vit_ap_student_app/features/home/model/milestone.dart';

class MilestoneCard extends StatelessWidget {
  final Milestone milestone;

  const MilestoneCard({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Monochrome hierarchy: the card sits one step above the page
    // surface (light gray in light mode, dark gray on black in dark).
    final cardColor = colorScheme.surfaceContainerHigh;
    final foreground = colorScheme.onSurface;
    final muted = colorScheme.onSurfaceVariant;

    final daysLeft = milestone.daysLeft();
    final hoursLeft = milestone.hoursLeft();

    final String headerLabel;
    final String countLabel;
    final String unitLabel;
    if (daysLeft >= 1) {
      headerLabel = 'APPROACHING IN';
      countLabel = '$daysLeft';
      unitLabel = 'days';
    } else if (hoursLeft >= 1) {
      headerLabel = 'APPROACHING IN';
      countLabel = '$hoursLeft';
      unitLabel = 'hours';
    } else if (!milestone.isPassed()) {
      headerLabel = 'APPROACHING IN';
      countLabel = '<1';
      unitLabel = 'hour';
    } else {
      headerLabel = 'WRAPPED UP';
      countLabel = 'Done';
      unitLabel = '';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            milestone.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: foreground,
            ),
          ),
          if (milestone.info != null && milestone.info!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              milestone.info!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.5,
                color: muted,
              ),
            ),
          ],
          const Spacer(),
          Text(
            headerLabel,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
              color: muted,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                countLabel,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  color: foreground,
                ),
              ),
              if (unitLabel.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  unitLabel,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: muted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
