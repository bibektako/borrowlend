import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isAutoModeEnabled;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.isAutoModeEnabled = false,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isAutoModeEnabled,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isAutoModeEnabled: isAutoModeEnabled ?? this.isAutoModeEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, isAutoModeEnabled];
}