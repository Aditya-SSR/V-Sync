import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vit_ap_student_app/core/providers/theme_mode_notifier.dart';
import 'package:vit_ap_student_app/core/providers/user_preferences_notifier.dart';
import 'package:vit_ap_student_app/features/account/view/widgets/developer_mode_tiles.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final bool isDeveloperModeEnabled;

  const SettingsPage({super.key, this.isDeveloperModeEnabled = false});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final userPreferences = ref.watch(userPreferencesProvider);
    final userPreferencesNotifier = ref.read(userPreferencesProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (widget.isDeveloperModeEnabled)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Iconsax.security_user_copy, size: 22),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // Appearance
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: Icon(
                userPreferences.isDarkModeEnabled
                    ? Iconsax.moon_copy
                    : Iconsax.sun_1_copy,
                color: colorScheme.onSurface,
              ),
              title: Text(
                'Dark mode',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: userPreferences.isDarkModeEnabled,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Font scale
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
            child: Text(
              'Font size (${(userPreferences.fontScale ?? 1.2).toStringAsFixed(1)}x)',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                Slider(
                  value: userPreferences.fontScale ?? 1.2,
                  min: 0.8,
                  max: 1.6,
                  divisions: 8,
                  label:
                      '${(userPreferences.fontScale ?? 1.2).toStringAsFixed(1)}x',
                  onChanged: (value) async {
                    final updatedPreferences = userPreferences.copyWith(
                      fontScale: value,
                    );
                    await userPreferencesNotifier.updatePreferences(
                      updatedPreferences,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0.8x', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                      Text('1.2x', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                      Text('1.6x', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (widget.isDeveloperModeEnabled) ...[
            const SizedBox(height: 20),
            const DeveloperModeTiles(),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
