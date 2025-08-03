import 'package:borrowlend/core/config/theme/theme_cubit.dart';
import 'package:borrowlend/core/config/theme/theme_state.dart';
import 'package:borrowlend/features/settings/presentation/view/theme_option_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}

void main() {
  late MockThemeCubit mockThemeCubit;

  setUp(() {
    mockThemeCubit = MockThemeCubit();
  });

  Widget makeTestableWidget(ThemeState state) {
    when(() => mockThemeCubit.state).thenReturn(state);
    when(() => mockThemeCubit.stream).thenAnswer((_) => Stream.value(state));
    return MaterialApp(
      home: BlocProvider<ThemeCubit>.value(
        value: mockThemeCubit,
        child: const Scaffold(
          body: ThemeOptionsSection(),
        ),
      ),
    );
  }

  testWidgets('displays current theme mode and toggles correctly', (tester) async {
    final state = ThemeState(themeMode: ThemeMode.light, isAutoModeEnabled: false);
    await tester.pumpWidget(makeTestableWidget(state));

    expect(find.text('Light Mode'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.text('Automatic Theme'), findsOneWidget);
  });

  testWidgets('taps Light Mode and triggers theme change if auto mode is off', (tester) async {
    final state = ThemeState(themeMode: ThemeMode.dark, isAutoModeEnabled: false);
    await tester.pumpWidget(makeTestableWidget(state));

    await tester.tap(find.widgetWithText(RadioListTile<ThemeMode>, 'Light Mode'));
    verify(() => mockThemeCubit.setTheme(ThemeMode.light)).called(1);
  });

  testWidgets('taps Dark Mode and triggers theme change if auto mode is off', (tester) async {
    final state = ThemeState(themeMode: ThemeMode.light, isAutoModeEnabled: false);
    await tester.pumpWidget(makeTestableWidget(state));

    await tester.tap(find.widgetWithText(RadioListTile<ThemeMode>, 'Dark Mode'));
    verify(() => mockThemeCubit.setTheme(ThemeMode.dark)).called(1);
  });

 
}
