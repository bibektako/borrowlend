import 'package:borrowlend/core/config/theme/theme_cubit.dart';
import 'package:borrowlend/core/config/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeOptionsSection extends StatelessWidget {
  const ThemeOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget rebuilds whenever the theme state changes.
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final bool isAutoModeEnabled = themeState.isAutoModeEnabled;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, "Appearance"),
            const SizedBox(height: 8),

            // --- Manual Theme Selection ---
            // These radio buttons are disabled if auto-mode is on.
            RadioListTile<ThemeMode>(
              title: const Text('Light Mode'),
              value: ThemeMode.light,
              groupValue: themeState.themeMode,
              onChanged: isAutoModeEnabled
                  ? null // Disable if auto mode is on
                  : (value) {
                      if (value != null) {
                        context.read<ThemeCubit>().setTheme(value);
                      }
                    },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark Mode'),
              value: ThemeMode.dark,
              groupValue: themeState.themeMode,
              onChanged: isAutoModeEnabled
                  ? null // Disable if auto mode is on
                  : (value) {
                      if (value != null) {
                        context.read<ThemeCubit>().setTheme(value);
                      }
                    },
            ),

            const Divider(height: 24),

            // --- Automatic Theme Switch ---
            SwitchListTile(
              title: const Text("Automatic Theme"),
              subtitle: const Text("Adjusts based on ambient light"),
              value: isAutoModeEnabled,
              onChanged: (isEnabled) {
                context.read<ThemeCubit>().toggleAutoMode(isEnabled);
              },
              secondary: const Icon(Icons.brightness_auto_outlined),
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        );
      },
    );
  }

  // Helper widget for section titles for consistency
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}