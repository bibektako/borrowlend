import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../login_view_model/login_view_model_test.dart';

// 1. --- Mocks and Fakes ---
class MockCreateUserUsecase extends Mock implements CreateUserUsecase {}

class FakeCreateUserUsecaseParams extends Fake
    implements CreateUserUsecaseParams {}

void main() {
  late SignupViewModel signupViewModel;
  late MockCreateUserUsecase mockCreateUserUsecase;

  // Test Constants
  const tUsername = 'testuser';
  const tEmail = 'test@gmail.com';
  const tPhone = '1234567890';
  const tPassword = 'password123';

  setUpAll(() {
    // Register fallback needed for Mocktail's `any()` matcher
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
    // TEST CASE 1: Successful Signup
    blocTest<SignupViewModel, SignupState>(
      'emits [loading, success] states when signup is successful',
      setUp: () {
        // Arrange: Use case will return a success (Right)
        when(
          () => mockCreateUserUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
      },
      build: () => signupViewModel,
      act:
          (bloc) => bloc.add(
            SignupUserEvent(
              // Note: The refactored event doesn't need context
              username: tUsername,
              email: tEmail,
              phone: tPhone,
              password: tPassword,
              confirmPassword: tPassword,
              context: MockBuildContext(),
            ),
          ),
      expect:
          () => <SignupState>[
            const SignupState(isLoading: true, isSuccess: false),
            const SignupState(isLoading: false, isSuccess: true),
          ],
    );

    // TEST CASE 2: Failed Signup
    blocTest<SignupViewModel, SignupState>(
      'emits [loading, failure] with an error message when signup fails',
      setUp: () {
        // Arrange: Use case will return a failure (Left)
        const failure = RemoteDatabaseFailure(message: 'Email already exists');
        when(
          () => mockCreateUserUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));
      },
      build: () => signupViewModel,
      act:
          (bloc) => bloc.add(
            SignupUserEvent(
              username: tUsername,
              email: tEmail,
              phone: tPhone,
              password: tPassword,
              confirmPassword: tPassword,
              context: MockBuildContext(),
            ),
          ),
      expect:
          () => <SignupState>[
            const SignupState(isLoading: true, isSuccess: false),
            const SignupState(
              isLoading: false,
              isSuccess: false,
              errorMessage:
                  'Email already exists', // Assert the error message is in the state
            ),
          ],
    );
  });
}
