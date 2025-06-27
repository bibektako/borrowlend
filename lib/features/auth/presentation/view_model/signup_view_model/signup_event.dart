import 'package:flutter/material.dart';

@immutable
sealed class SignupEvent {}

class SignupUserEvent extends SignupEvent {
  final BuildContext context;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  SignupUserEvent({
    required this.context,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
  });
}

class NavigateToLoginView extends SignupEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToLoginView({required this.context, required this.destination});
}
