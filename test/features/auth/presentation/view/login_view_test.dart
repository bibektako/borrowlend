import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    when(() => mockLoginViewModel.state).thenReturn(LoginState.initial());
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<LoginViewModel>.value(
        value: mockLoginViewModel,
        child: MaterialApp(home: LoginView()),
      ),
    );
  }

  group('LoginView', () {
    testWidgets('welcome text render', (WidgetTester tester) async {
      await pumpLoginView(tester);

      expect(find.text('Welcome back!'), findsOneWidget);
      // expect(find.text('Log into to your existing account.'), findsOneWidget);
    });

    testWidgets('login button render', (WidgetTester tester) async {
      await pumpLoginView(tester);

      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    group('Form Validation', () {
      testWidgets(
        'shows required error messages when email and password are empty',
        (WidgetTester tester) async {
          // Arrange
          await pumpLoginView(tester);

          // Act
          await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
          await tester.pump();
          // Assert
          expect(find.text('Please enter your email'), findsOneWidget);
          expect(find.text('Please enter a password'), findsOneWidget);
        },
      );

      testWidgets('shows error message for invalid email format', (
        WidgetTester tester,
      ) async {
        // Arrange
        await pumpLoginView(tester);
        final emailField = find.byType(TextFormField).first;

        // Act
        await tester.enterText(emailField, 'invalid-email');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump();

        // Assert
        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });
    });
    testWidgets('Login success', (tester) async {
      when(
        () => mockLoginViewModel.state,
      ).thenReturn(LoginState(isLoading: true, isSuccess: true));

      await pumpLoginView(tester);

      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'bibek@gmail.com');
      await tester.enterText(find.byType(TextField).at(1), 'bibek123');

      await tester.tap(find.byType(ElevatedButton).first);

      await tester.pumpAndSettle();

      expect(mockLoginViewModel.state.isSuccess, true);
    });
  });
}
