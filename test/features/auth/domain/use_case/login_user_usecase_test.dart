import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/repository/user_repository.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late LoginUserUsecase usecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUserUsecase(
      userRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  const tEmail = 'bibek@gmail.com';
  const tPassword = 'bibek123';
  const tToken = 'sample_auth_token';
  const tParams = LoginUserUsecaseParams(email: tEmail, password: tPassword);

  group('LoginUserUsecase', () {
    test(
      'should get token from repository, save it, and return token on success',
      () async {
        when(
          () => mockUserRepository.loginUser(tEmail, tPassword),
        ).thenAnswer((_) async => const Right(tToken));

        when(
          () => mockTokenSharedPrefs.saveToken(tToken),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase(tParams);

        expect(result, const Right(tToken));
        verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
        verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
        verifyNoMoreInteractions(mockUserRepository);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );

    test('should return a Failure when the repository call fails', () async {
      const tFailure = RemoteDatabaseFailure(message: 'Invalid credentials');
      when(
        () => mockUserRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));
      final result = await usecase(tParams);
      expect(result, const Left(tFailure));
      verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });
  });
}
