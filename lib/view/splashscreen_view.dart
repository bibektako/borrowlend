

import 'dart:async';

import 'package:borrowlend/view/onboarding_view.dart';
import 'package:flutter/material.dart';

class SplashscreenView extends StatefulWidget{
  const SplashscreenView ({super.key});
  @override
  State<SplashscreenView> createState() => _SplashscreenView();
}

class _SplashscreenView extends State<SplashscreenView>{
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>OnBoardingView()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(12),
         
              child:Column(
                children: [
                  Center(child: Image.asset('assets/image/onboarding.png')),
                ],
              )
           
      
      
      )

    );
  }
}