
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupView();
}

class _SignupView extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo
                  Image.asset(
                    'assets/image/loginimage.png',
                      width: double.infinity,
                       height: 180,
                      fit: BoxFit.fitHeight,
                  ),
              
                  
              
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
                  TextFormField(
                    controller: _emailController,
                    decoration:  InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: "yourmail@mail.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Enter the email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
              
                  // Password Field
                  const Text(
                    "Password",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
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
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Enter password";
                      }else if(value.length < 6){
                        return "Password must be at least 6 character";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
              
                  // Confirm Password Field
                  const Text(
                    "Confirm Password",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
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
                    validator:(value) {
                      if(value == null || value.isEmpty){
                        return "Confirm password cannot be empty";
                      }
                      return null;
                    },
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
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String confirmPassword = _confirmPasswordController.text.trim();
              
                          if(password != confirmPassword){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Password and Confirm Password don't match"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red
                              ));
                          }else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration success"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.blue,
                                ));
                                Navigator.push(context, MaterialPageRoute(builder:(_) => const LoginView() ));
                          }
                        }
                      },
                      child: const Text("Register",
                      style: TextStyle(color: Colors.white),),
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
          ),
        ),
      ),
    );
  }
}
