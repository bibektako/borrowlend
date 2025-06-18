import 'package:borrowlend/core/network/hive_service.dart';
import 'package:borrowlend/features/auth/data/data_source/user_data_source.dart';
import 'package:borrowlend/features/auth/data/model/user_hive_model.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';


class UserLocalDatasource implements IUserDataSource{
  final HiveService _hiveService;

  //Dependency injection
  //constructor

  UserLocalDatasource({ required HiveService hiveService})
  : _hiveService = hiveService;

  @override
  Future<void> createUser(UserEntity user)async {
    try {
      //convert to Model
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.createUser(userHiveModel);
    } catch (e) {
      throw Exception('Failed to add user $e');
    }
   
  }

  @override
  Future<void> deleteUser(String userId) async{
   try {
     await _hiveService.deleteUser(userId);
   } catch (e) {
     throw Exception('Failed to delete user $e');
   }
  }
  
  @override
  Future<String> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
  
  @override
  Future<String> loginUser(String email, String password) async{
    try {
      final user = await _hiveService.loginUser(email, password);
      if(user == null){
        throw Exception('Invalid username or password');
      }
      return user.userId ?? '';
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}