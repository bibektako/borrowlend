import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/auth/data/data_source/user_data_source.dart';
import 'package:borrowlend/features/auth/data/model/user_api_model.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:dio/dio.dart';

class UserRemoteDatasource  implements IUserDataSource{
  final ApiService  _apiService;
  UserRemoteDatasource({ required ApiService apiService}) : _apiService = apiService;

  @override
  Future<void> createUser(UserEntity user) async{
   try {
    final userAPiModel = UserApiModel.formEntity(user);
    final response = await _apiService.dio.post(
      ApiEndpoints.register,
      data:  userAPiModel.toJson(),
    );
    if (response.statusCode == 200){
      return;
    }else{
      throw Exception(
        'Failed to register user: ${response.statusMessage}'
      );
    }
    
     
   }on DioException catch (e){
    throw Exception('Failed to register user: ${e.message}');
   } 
   
   catch (e) {
     throw Exception('Failed to register student: $e');
   }
  }

  @override
  Future<void> deleteUser(String userId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser(String email, String password) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

}