import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> createUser(UserEntity user);
  Future<(UserEntity, String)> loginUser(String email, String password);
  Future<String> getCurrentUser();
  Future<void> deleteUser(String userId);
}
