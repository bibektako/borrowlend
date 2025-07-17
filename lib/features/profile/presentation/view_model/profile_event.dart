import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:flutter/material.dart';

@immutable
sealed class ProfileEvent {}

final class LoadUserProfile extends ProfileEvent {}

final class UpdateUserProfile extends ProfileEvent {
  final UserProfileEntity profile;

  UpdateUserProfile(this.profile);
}

final class NavigateToProfilePage extends ProfileEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToProfilePage({
    required this.context,
    required this.destination,
  });
}