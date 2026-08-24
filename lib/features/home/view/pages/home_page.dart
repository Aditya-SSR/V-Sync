import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_ap_student_app/features/home/view/widgets/mess/mess_menu_section.dart';
import 'package:vit_ap_student_app/features/home/view/widgets/milestones/milestones_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MilestonesSection(),
              MessMenuSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
