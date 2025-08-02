import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/domain/repository/user_repository.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes remain the same
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

  // --- ARRANGE (Setup Test Data) ---
  const tEmail = 'bibek@gmail.com';
  const tPassword = 'bibek123';
  const tToken = 'sample_auth_token';
  const tParams = LoginUserUsecaseParams(email: tEmail, password: tPassword);

  // 1. Create a sample UserEntity for testing
  final tUser = UserEntity(
    userId: '1',
    username: 'bibektako',
    email: tEmail,
    phone: '9999999999',
    password: 'Password@1'
  );

  // 2. Create the expected response entity that the use case should return
  final tLoginResponseEntity = LoginResponseEntity(user: tUser, token: tToken);


  group('LoginUserUsecase', () {
    test(
      'should get user and token from repository, save the token, and return LoginResponseEntity on success',
      () async {
        // --- ARRANGE ---
        
        // 3. FIX: Mock the repository to return the correct record type: (UserEntity, String)
        when(
          () => mockUserRepository.loginUser(tEmail, tPassword),
        ).thenAnswer((_) async => Right((tUser, tToken)));

        // This part was already correct
        when(
          () => mockTokenSharedPrefs.saveToken(tToken),
        ).thenAnswer((_) async => const Right(null));


        // --- ACT ---
        final result = await usecase(tParams);


        // --- ASSERT ---
        
        // 4. FIX: Expect the result to be a Right containing the LoginResponseEntity
        expect(result, Right(tLoginResponseEntity));

        // Verifications remain the same and are correct
        verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
        verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
        verifyNoMoreInteractions(mockUserRepository);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );

    test('should return a Failure when the repository call fails', () async {
      // --- ARRANGE ---
      const tFailure = RemoteDatabaseFailure(message: 'Invalid credentials');
      
      // This test was already correct and needs no changes
      when(
        () => mockUserRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // --- ACT ---
      final result = await usecase(tParams);

      // --- ASSERT ---
      expect(result, const Left(tFailure));
      verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}