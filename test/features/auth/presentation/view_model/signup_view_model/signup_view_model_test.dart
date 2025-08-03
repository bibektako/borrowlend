import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';

// ✅ Mocks and Fakes
class MockCreateUserUsecase extends Mock implements CreateUserUsecase {}

class FakeCreateUserUsecaseParams extends Fake
    implements CreateUserUsecaseParams {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late SignupViewModel signupViewModel;
  late MockCreateUserUsecase mockCreateUserUsecase;

  // ✅ Dummy constants
  const tUsername = 'testuser';
  const tEmail = 'test@gmail.com';
  const tPhone = '1234567890';
  const tPassword = 'password123';

  setUpAll(() {
    registerFallbackValue(FakeCreateUserUsecaseParams());
  });

  setUp(() {
    mockCreateUserUsecase = MockCreateUserUsecase();
    signupViewModel = SignupViewModel(createUserUsecase: mockCreateUserUsecase);
  });

  tearDown(() {
    signupViewModel.close();
  });

  test('initial state is correct', () {
    expect(signupViewModel.state, const SignupState.initial());
  });

  group('SignupUserEvent', () {
    blocTest<SignupViewModel, SignupState>(
      'emits [loading, success] states when signup is successful',
      build: () => signupViewModel,
      setUp: () {
        when(() => mockCreateUserUsecase(any()))
            .thenAnswer((_) async => const Right(null));
      },
      act: (bloc) => bloc.add(
        SignupUserEvent(
          username: tUsername,
          email: tEmail,
          phone: tPhone,
          password: tPassword,
          confirmPassword: tPassword,
          context: MockBuildContext(),
        ),
      ),
      expect: () => [
        const SignupState(isLoading: true, isSuccess: false),
        const SignupState(isLoading: false, isSuccess: true),
      ],
      verify: (_) {
        verify(() => mockCreateUserUsecase(any())).called(1);
      },
    );

    blocTest<SignupViewModel, SignupState>(
      'emits [loading, failure] with error message when signup fails',
      build: () => signupViewModel,
      setUp: () {
        when(() => mockCreateUserUsecase(any())).thenAnswer(
          (_) async =>
              const Left(RemoteDatabaseFailure(message: 'Email already exists')),
        );
      },
      act: (bloc) => bloc.add(
        SignupUserEvent(
          username: tUsername,
          email: tEmail,
          phone: tPhone,
          password: tPassword,
          confirmPassword: tPassword,
          context: MockBuildContext(),
        ),
      ),
      expect: () => [
        const SignupState(isLoading: true, isSuccess: false),
        const SignupState(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Email already exists',
        ),
      ],
      verify: (_) {
        verify(() => mockCreateUserUsecase(any())).called(1);
      },
    );
  });
}
