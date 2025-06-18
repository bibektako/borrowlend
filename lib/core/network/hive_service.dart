import 'dart:ffi';

import 'package:borrowlend/app/constant/hive_table_constant.dart';
import 'package:borrowlend/features/auth/data/model/user_hive_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}borrow_lend.db';

    Hive.init(path);
    // register Adapter
    Hive.registerAdapter(UserHiveModelAdapter());
  }
    //Queries
    Future<void> createUser(UserHiveModel user) async {
      var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
      await box.put(user.userId, user);
    }
    
    Future<UserHiveModel?> loginUser(
      String email,
      String password,
    )async{
      var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox,);
      var user = box.values.firstWhere(
        (user) => user.email == email && user.password == password, 
        orElse: () => throw Exception('Invalid username or password')
      );
     return user;
    }

    Future<void> deleteUser(String userId) async {
      var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
      await box.delete(userId);
    }
  
}
