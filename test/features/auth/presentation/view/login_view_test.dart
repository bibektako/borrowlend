import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginViewModel extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}


void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUpAll(() {
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();

    // Fix: Add isSuccess parameter
    when(() => mockLoginViewModel.state).thenReturn(LoginState(
      isLoading: false,
      isSuccess: false,
    ));

    whenListen(
      mockLoginViewModel,
      Stream<LoginState>.fromIterable([
        LoginState(isLoading: false, isSuccess: false),
      ]),
    );
  });

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginViewModel>.value(
          value: mockLoginViewModel,
          child: LoginView(),
        ),
      ),
    );
  }


}
