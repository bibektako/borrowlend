import 'package:borrowlend/common/category_explorer.dart';
import 'package:borrowlend/theme/theme_data.dart';
import 'package:borrowlend/view/home_page_view.dart';
import 'package:borrowlend/view/splashscreen_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashscreenView(),
      theme: getApplicationTheme(),
    );
  }
}
