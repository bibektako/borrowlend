import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/image/loginimage.png', height: 50, width: 50),
            SizedBox(height: 12),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  RichText(
                    text: const TextSpan(
                      text: "Welcome back!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Log into your account",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text("Email", style: TextStyle(color: Colors.black, fontSize: 18)),
            Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: "Yourmail@mail.com",
                  border: InputBorder.none,
                ),

                keyboardType: TextInputType.numberWithOptions(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Password",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(height: 5),
            Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: "Input your password",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              child: RichText(
                text: const TextSpan(
                  text: "Forgot your password?",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Reset Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text("login"),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},

                child: Text("Login with Google"),
              ),
            ),

            SizedBox(height: 200),

            SizedBox(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: "Don`t have an account?",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Click here",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
