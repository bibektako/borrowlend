import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupView();
}

class _SignupView extends State<SignupView> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Image.asset(
              'assets/image/loginimage.png',
            ), // Replace with your logo
            // const SizedBox(height: 32),

            // Title
            const Text(
              "Create your account",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              "Create new account",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 32),

            // Email Field
            const Text(
              "Email",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: "yourmail@mail.com",
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            const Text(
              "Password",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
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
            const SizedBox(height: 20),

            // Confirm Password Field
            const Text(
              "Confirm Password",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  hintText: "Input your password again",
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
            const SizedBox(height: 24),

            // Register Button
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
                child: const Text("Register"),
              ),
            ),
            const SizedBox(height: 16),

            // Google Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Register with Google",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
