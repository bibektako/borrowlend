
import 'package:borrowlend/app/app.dart';
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/network/hive_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  final hiveService = serviceLocator<HiveService>();
  await hiveService.init();
  runApp(const App());
}
