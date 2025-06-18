import 'package:borrowlend/app/app.dart';
import 'package:borrowlend/core/network/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();

  runApp(const App());
}
