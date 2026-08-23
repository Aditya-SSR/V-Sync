import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vit_ap_student_app/core/providers/bottom_nav_provider.dart';
import 'package:vit_ap_student_app/features/account/view/pages/account_page.dart';
import 'package:vit_ap_student_app/features/attendance/view/pages/attendance_page.dart';
import 'package:vit_ap_student_app/features/home/view/pages/home_page.dart';
import 'package:vit_ap_student_app/features/timetable/view/pages/timetable_page.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends ConsumerState<BottomNavBar> {
  List<Widget> _buildPages() {
    return const [
      HomePage(),
      TimetablePage(),
      AttendancePage(),
      AccountPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && currentIndex != 0) {
          ref.read(bottomNavIndexProvider.notifier).state = 0;
        }
      },
      child: Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: KeyedSubtree(
            key: ValueKey(currentIndex),
            child: _buildPages()[currentIndex],
          ),
        ),
        // The Scaffold hands this slot the full screen width and loose,
        // screen-sized height constraints. Align with heightFactor: 1
        // shrink-wraps the slot to the capsule's real height instead of
        // letting it expand, and pins it to the bottom.
        bottomNavigationBar: const _FloatingCapsuleNavBar(),
      ),
    );
  }
}

class _FloatingCapsuleNavBar extends ConsumerWidget {
  const _FloatingCapsuleNavBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14, left: 24, right: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              // Blurs whatever scrolls behind the capsule.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.9),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _NavItem(
                        icon: Iconsax.home,
                        isActive: currentIndex == 0,
                        onTap: () => ref
                            .read(bottomNavIndexProvider.notifier)
                            .state = 0,
                      ),
                      const SizedBox(width: 8),
                      _NavItem(
                        icon: Iconsax.calendar,
                        isActive: currentIndex == 1,
                        onTap: () => ref
                            .read(bottomNavIndexProvider.notifier)
                            .state = 1,
                      ),
                      const SizedBox(width: 8),
                      _NavItem(
                        icon: Iconsax.document,
                        isActive: currentIndex == 2,
                        onTap: () => ref
                            .read(bottomNavIndexProvider.notifier)
                            .state = 2,
                      ),
                      const SizedBox(width: 8),
                      _NavItem(
                        icon: Iconsax.user,
                        isActive: currentIndex == 3,
                        onTap: () => ref
                            .read(bottomNavIndexProvider.notifier)
                            .state = 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? colorScheme.primary : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
