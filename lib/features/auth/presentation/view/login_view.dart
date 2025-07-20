import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/auth/presentation/view/signup_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 1. WRAP THE SCAFFOLD WITH A BLOCPROVIDER
    // This creates and provides the LoginViewModel for this screen.
    return BlocProvider(
      create: (context) => serviceLocator<LoginViewModel>(),
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              // 2. USE A BUILDER TO GET A CONTEXT THAT IS *BELOW* THE PROVIDER
              // This ensures that any `context.read` calls inside will find the ViewModel.
              child: Builder(
                builder: (context) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/image/loginimage.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.fitHeight,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Welcome back!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Inter Bold',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Log into your existing account.",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        const SizedBox(height: 32),
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
                        _PasswordTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implement Forgot Password
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontFamily: 'Inter Bold',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<LoginViewModel, LoginState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  elevation: 1,
                                  shadowColor: Colors.blueAccent.withOpacity(
                                    0.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed:
                                    state.isLoading
                                        ? null
                                        : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<LoginViewModel>().add(
                                              LoginIntoSystemEvent(
                                                context: context,
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              ),
                                            );
                                          }
                                        },
                                child:
                                    state.isLoading
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Register here",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontFamily: 'Inter Bold',
                                  ),
                                  // THIS CALL WILL NOW WORK
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          context.read<LoginViewModel>().add(
                                            NavigateToSignupView(
                                              context: context,
                                              destination: SignupView(),
                                            ),
                                          );
                                        },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// _PasswordTextField widget remains the same...
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
