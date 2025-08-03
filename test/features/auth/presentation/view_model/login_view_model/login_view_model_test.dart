import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockLoginUserUsecase extends Mock implements LoginUserUsecase {}

class MockSessionCubit extends Mock implements SessionCubit {}

class MockApiService extends Mock implements ApiService {}

class FakeUserEntity extends Fake implements UserEntity {}

class FakeLoginParams extends Fake implements LoginUserUsecaseParams {}

void main() {
  late MockLoginUserUsecase mockLoginUserUsecase;
  late MockSessionCubit mockSessionCubit;
  late MockApiService mockApiService;
  late LoginViewModel loginViewModel;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockLoginUserUsecase = MockLoginUserUsecase();
    mockSessionCubit = MockSessionCubit();
    mockApiService = MockApiService();

    // Inject mock into service locator
    serviceLocator.registerSingleton<ApiService>(mockApiService);

    loginViewModel = LoginViewModel(mockLoginUserUsecase, mockSessionCubit);
  });

  tearDown(() {
    loginViewModel.close();
    serviceLocator.reset(); // Cleanup
  });

  test('initial state is LoginState.initial()', () {
    expect(loginViewModel.state, LoginState.initial());
  });

  blocTest<LoginViewModel, LoginState>(
    'emits [loading, success] when login succeeds',
    build: () => loginViewModel,
    setUp: () {
      final user = UserEntity(
        userId: '123',
        username: 'testuser',
        email: 'test@gmail.com',
        phone: '1234567890',
        password: '',
      );
      const token = 'fake-token';

      when(() => mockLoginUserUsecase(any())).thenAnswer(
        (_) async => Right(LoginResponseEntity(user: user, token: token)),
      );

      when(() => mockSessionCubit.showSession(user)).thenReturn(null);
      when(() => mockApiService.setAuthToken(token)).thenReturn(null);
    },
    act: (bloc) {
      // Fake context with mounted = false prevents Navigator.push
      final fakeContext = _FakeContext();
      bloc.add(
        LoginIntoSystemEvent(
          context: fakeContext,
          email: 'test@gmail.com',
          password: 'password123',
        ),
      );
    },
    expect:
        () => [
          LoginState(isLoading: true, isSuccess: false, user: null),
          LoginState(
            isLoading: false,
            isSuccess: true,
            user: UserEntity(
              userId: '123',
              username: 'testuser',
              email: 'test@gmail.com',
              phone: '1234567890',
              password: '',
            ),
          ),
        ],
    verify: (_) {
      verify(() => mockLoginUserUsecase(any())).called(1);
      verify(() => mockSessionCubit.showSession(any())).called(1);
      verify(() => mockApiService.setAuthToken(any())).called(1);
    },
  );

  
}

class _FakeContext extends Fake implements BuildContext {
  @override
  bool get mounted => false;
}
