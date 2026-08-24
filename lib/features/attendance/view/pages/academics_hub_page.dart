import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vit_ap_student_app/features/attendance/view/pages/attendance_page.dart';
import 'package:vit_ap_student_app/features/home/view/pages/exam_schedule_page.dart';
import 'package:vit_ap_student_app/features/home/view/pages/grade_history_page.dart';
import 'package:vit_ap_student_app/features/home/view/pages/marks_page.dart';

/// Landing page for the third tab: entry points to Attendance, Marks
/// and Grade history.
class AcademicsHubPage extends StatelessWidget {
  const AcademicsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Academics',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _HubCard(
                icon: Iconsax.tick_circle,
                title: 'Attendance',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (builder) => const AttendancePage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _HubCard(
                icon: Iconsax.document_text,
                title: 'Marks',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (builder) => const MarksPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _HubCard(
                icon: Iconsax.award,
                title: 'Grades',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (builder) => const GradeHistoryPage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _HubCard(
                icon: Iconsax.calendar_tick,
                title: 'Exam Schedule',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (builder) => const ExamSchedulePage(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HubCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colorScheme.outlineVariant, width: 0.75),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22, color: colorScheme.onPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
