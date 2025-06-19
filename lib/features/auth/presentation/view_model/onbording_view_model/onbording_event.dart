import 'package:flutter/material.dart';

@immutable
sealed class OnbordingEvent {}

class NavigateToSignupView extends OnbordingEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToSignupView({required this.context, required this.destination});
}

class NavigateToLoginView extends OnbordingEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToLoginView({required this.context, required this.destination});
}
