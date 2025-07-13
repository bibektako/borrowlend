import 'package:borrowlend/features/auth/presentation/view/signup_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockSignupViewModel extends MockBloc<SignupEvent, SignupState>
    implements SignupViewModel {}

void main() {
  late MockSignupViewModel mockSignupViewModel;

  Future<void> pumpSignupView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<SignupViewModel>.value(
        value: mockSignupViewModel,
        child: MaterialApp(home: SignupView()),
      ),
    );
  }

  setUp(() {
    mockSignupViewModel = MockSignupViewModel();
    when(() => mockSignupViewModel.state).thenReturn(SignupState.initial());
  });

  group('SignupView', () {
    testWidgets('renders initial UI elements correctly', (
      WidgetTester tester,
    ) async {
      await pumpSignupView(tester);
      expect(find.text('Create your account'), findsOneWidget);
      expect(find.text("Let's get you set up."), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    });

    group('Form Validation', () {
      testWidgets(
        'shows required error messages when form is submitted empty',
        (WidgetTester tester) async {
          await pumpSignupView(tester);

          final createButton = find.widgetWithText(ElevatedButton, 'Register');
          await tester.ensureVisible(createButton);
          await tester.tap(createButton);
          await tester.pump();

          expect(find.text('Please enter a username'), findsOneWidget);
          expect(find.text('Please enter your phone number'), findsOneWidget);
          expect(
            find.text('Please enter a valid email address'),
            findsOneWidget,
          );
          expect(find.text('Password must be at least 6 characters'), findsOneWidget);
          // expect(find.text('Please confirm your password'), findsOneWidget);
        },
      );
    });
  });
}
