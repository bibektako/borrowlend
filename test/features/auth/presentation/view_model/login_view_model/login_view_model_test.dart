import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUserUsecase extends Mock implements LoginUserUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeLoginUserUsecaseParams extends Fake
    implements LoginUserUsecaseParams {}

class FakeNavigateToHomeView extends Fake implements NavigateToHomeView {}

void main() {
  late LoginViewModel loginViewModel;
  late MockLoginUserUsecase mockLoginUserUsecase;
  late MockBuildContext mockBuildContext;

  // Constants
  const tEmail = 'test@gmail.com';
  const tPassword = 'password123';
  const tToken = 'sample-token';

  setUpAll(() {
    registerFallbackValue(FakeLoginUserUsecaseParams());
    registerFallbackValue(FakeNavigateToHomeView());
  });

  setUp(() {
    mockLoginUserUsecase = MockLoginUserUsecase();
    mockBuildContext = MockBuildContext();
    loginViewModel = LoginViewModel(mockLoginUserUsecase);

    when(() => mockBuildContext.mounted).thenReturn(false);
  });

  tearDown(() {
    loginViewModel.close();
  });

  test('initial state is correct', () {
    expect(loginViewModel.state, LoginState.initial());
  });
  blocTest<LoginViewModel, LoginState>(
    'emits [isLoading=true] then [isLoading=false, isSuccess=true] when login is successful',
    // ARRANGE
    setUp: () {
      when(
        () => mockLoginUserUsecase(any()),
      ).thenAnswer((_) async => const Right(tToken));
    },
    build: () => loginViewModel,
    // ACT
    act:
        (bloc) => bloc.add(
          LoginIntoSystemEvent(
            context: mockBuildContext,
            email: tEmail,
            password: tPassword,
          ),
        ),

    expect:
        () => <LoginState>[
          LoginState(isLoading: true, isSuccess: false),
          LoginState(isLoading: false, isSuccess: true),
        ],
  );
}
