import 'package:borrowlend/view/login_view.dart';
import 'package:borrowlend/view/onboarding_view.dart';
import 'package:borrowlend/view/signup_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget{
  const App ({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(debugShowCheckedModeBanner: false,
    home: OnBoardingView());
  }
}