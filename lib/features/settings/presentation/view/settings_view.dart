import 'package:borrowlend/features/settings/presentation/view/theme_option_selection.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: const [
          // Section for theme and appearance settings
          ThemeOptionsSection(),

          // You can add more sections here in the future
          // e.g., Divider(), AccountSettingsSection(),
        ],
      ),
    );
  }
}