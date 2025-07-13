import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class SignupView extends StatelessWidget {
  SignupView({super.key});

  // Controllers and Keys are final properties of the StatelessWidget
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupViewModel, SignupState>(
      // The listener handles one-time actions (side-effects) based on state changes.
      listener: (context, state) {
        // On Success: Show a green snackbar and navigate away.
        if (state.isSuccess) {
          showMySnackBar(
            context: context,
            message: "Registration Successful!",
            color: Colors.green,
          );
          // After success, navigate to the login screen, replacing the current one.
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => LoginView()));
        }
        // On Error: Show a red snackbar with the error message from the BLoC.
        else if (state.errorMessage != null) {
          showMySnackBar(
            context: context,
            message: state.errorMessage!,
            color: Colors.red,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
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

                    // --- Form Fields ---
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
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        labelText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
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
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _PasswordTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (_passwordController.text != value) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // --- Register Button ---
                    // This button rebuilds based on the BLoC's loading state.
                    BlocBuilder<SignupViewModel, SignupState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // Disable the button when loading.
                            onPressed:
                                state.isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        // Dispatch the clean event (no BuildContext).
                                        context.read<SignupViewModel>().add(
                                          SignupUserEvent(
                                            username:
                                                _usernameController.text.trim(),
                                            phone: _phoneController.text.trim(),
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text,
                                            confirmPassword:
                                                _confirmPasswordController.text,
                                            context: context,
                                          ),
                                        );
                                      }
                                    },
                            // Show a loading indicator or text based on the state.
                            child:
                                state.isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      "Register",
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

                    // --- Login Link ---
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
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => LoginView(),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A dedicated StatefulWidget to manage the visibility toggle of a password field.
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
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
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
