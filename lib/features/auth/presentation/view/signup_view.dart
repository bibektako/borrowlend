import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class SignupView extends StatelessWidget {
  SignupView({super.key});

  // Controllers and Keys are now final properties of the StatelessWidget
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is now controlled by the central theme
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Consistent padding
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Placeholder for a logo or illustration

                  // Title
                  const Text(
                    "Create your account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Inter Bold',
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    "Let's get you set up.",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  const SizedBox(height: 32),

                  // Username Field - Now uses the central theme
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      labelText: "Username",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a username";
                      }
                      if (value.length < 4) {
                        return "Username must be at least 4 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_outlined),
                      labelText: "Phone Number",
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  _PasswordTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  _PasswordTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        elevation: 1,
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SignupViewModel>().add(
                            SignupUserEvent(
                              context: context,
                              username: _usernameController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Login here",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontFamily: 'Inter Bold',
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to Login Screen
                                    print("Navigate to Login");
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A dedicated StatefulWidget to manage the state of a password text field.
class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.controller,
    this.labelText,
    this.validator,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        // All styles are inherited from the theme, only unique properties are defined here
        labelText: widget.labelText,
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.grey.shade500,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey.shade500,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      validator: widget.validator,
    );
  }
}
