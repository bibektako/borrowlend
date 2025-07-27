import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:equatable/equatable.dart';

// The different statuses the profile screen can be in.
enum ProfileStatus { initial, loading, success, failure, saving, logoutSuccess }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfileEntity? userProfile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userProfile,
    this.errorMessage,
  });

  // Initial state of the view model
  factory ProfileState.initial() {
    return const ProfileState();
  }

  // Helper method to create a copy of the state with new values
  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileEntity? userProfile,
    // Use a function for the error message to handle nullability cleanly
    String? Function()? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, userProfile, errorMessage];
}
