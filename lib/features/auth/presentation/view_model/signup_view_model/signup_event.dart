import 'package:flutter/material.dart';

@immutable
sealed class SignupEvent {}

class SignupUserEvent extends SignupEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String confirmPassword;

  SignupUserEvent({
    required this.context,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class NavigateToLoginView extends SignupEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToLoginView({required this.context, required this.destination});
}
