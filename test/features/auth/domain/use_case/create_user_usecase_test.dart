import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/domain/repository/user_repository.dart';
import 'package:borrowlend/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for the repository dependency.
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late CreateUserUsecase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = CreateUserUsecase(userRepository: mockUserRepository);
  });

  // Consistent test data
  const tUsername = 'testuser';
  const tEmail = 'test@example.com';
  const tPhone = '1234567890';
  const tPassword = 'password123';

  const tParams = CreateUserUsecaseParams(
    username: tUsername,
    email: tEmail,
    phone: tPhone,
    password: tPassword,
  );

  // The entity that the usecase is expected to create.
  final tUserEntity = UserEntity(
    username: tUsername,
    email: tEmail,
    phone: tPhone,
    password: tPassword,
    location: null,
    bio: null,
  );

  group('CreateUserUsecase', () {
    test(
      'should call createUser on the repository with the correct UserEntity and return success',
      () async {
        // ARRANGE
        when(
          () => mockUserRepository.createUser(tUserEntity),
        ).thenAnswer((_) async => const Right(null));

        // ACT
        final result = await usecase(tParams);

        // ASSERT
        expect(result, const Right(null));
        verify(() => mockUserRepository.createUser(tUserEntity)).called(1);
        verifyNoMoreInteractions(mockUserRepository);
      },
    );

    test(
      'should return a Failure when the call to the repository is unsuccessful',
      () async {
        // ARRANGE
        const tFailure = RemoteDatabaseFailure(
          message: 'Error creating user on the server.',
        );

        // **** THE FIX IS HERE ****
        // Instead of using any(), we specify the exact entity we expect.
        // This makes the test more precise and avoids the error.
        when(
          () => mockUserRepository.createUser(tUserEntity),
        ).thenAnswer((_) async => const Left(tFailure));

        // ACT
        final result = await usecase(tParams);

        // ASSERT
        expect(result, const Left(tFailure));
        verify(() => mockUserRepository.createUser(tUserEntity)).called(1);
        verifyNoMoreInteractions(mockUserRepository);
      },
    );
  });
}
