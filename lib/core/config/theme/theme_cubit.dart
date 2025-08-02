import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'theme_state.dart'; // Import the new state file

class ThemeCubit extends HydratedCubit<ThemeState> {
  // Define a threshold for what we consider "dark".
  // This is adjustable. Lower values mean it needs to be darker to switch.
  static const int _darkThresholdLux = 15;

  ThemeCubit() : super(const ThemeState());

  /// Manually sets the theme (when user taps the icon button).
  /// This will also disable auto-mode.
  void setTheme(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode, isAutoModeEnabled: false));
  }

  /// Toggles the automatic sensor-based theme switching.
  void toggleAutoMode(bool isEnabled) {
    emit(state.copyWith(isAutoModeEnabled: isEnabled));
    if (!isEnabled) {
      // If user turns off auto, revert to system default
      emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }

  /// Called by our sensor controller to update the theme based on light level.
 
  void updateThemeFromSensor(int luxValue) {
    if (!state.isAutoModeEnabled) return;

    final newThemeMode = luxValue < _darkThresholdLux ? ThemeMode.dark : ThemeMode.light;

    if (newThemeMode != state.themeMode) {
      emit(state.copyWith(themeMode: newThemeMode));
    }
  }

  // --- HydratedBloc Implementation ---

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeState(
        themeMode: ThemeMode.values.byName(json['themeMode']),
        isAutoModeEnabled: json['isAutoModeEnabled'] ?? false,
      );
    } catch (_) {
      return const ThemeState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      'themeMode': state.themeMode.name,
      'isAutoModeEnabled': state.isAutoModeEnabled,
    };
  }
}