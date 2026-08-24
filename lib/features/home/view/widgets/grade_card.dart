import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vit_ap_student_app/core/models/grade_history.dart';

class GradeCard extends StatelessWidget {
  final Course course;

  const GradeCard({
    super.key,
    required this.course,
  });

  /// Monochrome-friendly grade hierarchy: greens at the top, warm tones
  /// in the middle, red at the bottom.
  static (Color, Color) _gradeColors(String grade) {
    switch (grade.trim().toUpperCase()) {
      case 'S':
        return (const Color(0xFFBFE6C8), const Color(0xFF1B5E20)); // light green
      case 'A':
        return (const Color(0xFF2E7D32), Colors.white); // dark green
      case 'B':
        return (const Color(0xFF66BB6A), Colors.white); // medium green
      case 'C':
        return (const Color(0xFFAFB42B), Colors.white); // olive / lime
      case 'D':
        return (const Color(0xFFF9A825), Colors.white); // amber
      case 'E':
        return (const Color(0xFFEF6C00), Colors.white); // orange
      case 'F':
        return (const Color(0xFFC62828), Colors.white); // red
      default:
        return (const Color(0xFF212121), Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (badgeColor, badgeTextColor) = _gradeColors(course.grade);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant, width: 0.75),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Grade badge
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  course.grade,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: badgeTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.5,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      course.courseCode,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.outlineVariant.withValues(alpha: 0),
                  colorScheme.outlineVariant.withValues(alpha: 0.6),
                  colorScheme.outlineVariant.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Meta row: credits, exam month, course type
          Row(
            children: [
              Icon(
                Iconsax.book_copy,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Text(
                '${course.credits} Credits',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Iconsax.calendar_copy,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Text(
                course.examMonth,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Iconsax.medal_star_copy,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  course.courseType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
