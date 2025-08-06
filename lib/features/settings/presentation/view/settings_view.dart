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
          ThemeOptionsSection(),

        ],
      ),
    );
  }
}