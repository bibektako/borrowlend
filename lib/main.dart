import 'package:borrowlend/app/app.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/core/network/hive_service.dart';
import 'package:borrowlend/features/auth/data/model/user_hive_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  final hiveService = serviceLocator<HiveService>();
  await hiveService.init();

  // final box = await Hive.openBox<UserHiveModel>("userBox");
  // for (var user in box.values) {
  //   debugPrint(user.toString());
  // }
  // final tokenSharedPref = serviceLocator<TokenSharedPrefs>();
  // final token = await tokenSharedPref.getToken();
  // debugPrint("Shared Pref Token: $token");

  runApp(const App());
}
