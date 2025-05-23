import 'package:borrowlend/view/login_view.dart';
import 'package:borrowlend/view/signup_view.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingView();
}

class _OnBoardingView extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 361,width: 450,
                  child: Image.asset('assets/image/onboarding.png')),
                Text(
                  "Borrow and lend easily Quickly!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Borrow easily and conveniently, with quick access anytime, anywhere.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height:33),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const LoginView()));
                    },
                    child: Text("Get Started",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                    ),
                    onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (_)=>const SignupView()));
                    }, child: Text("I`m new, sign me up",style: TextStyle( fontSize: 15,fontWeight: FontWeight.bold))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
