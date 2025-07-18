import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:equatable/equatable.dart';

/// Enum to represent the different statuses of the profile feature.
/// This helps in building a reactive UI that responds to state changes.
enum ProfileStatus {
  initial,      // The state before any action has been taken.
  loading,      // The app is fetching the user profile.
  success,      // The user profile was fetched successfully.
  failure,      // An error occurred while fetching or updating.
  saving,       // The app is in the process of saving the user's updated profile.
  saveSuccess   // The profile was saved successfully.
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfileEntity? userProfile;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.userProfile,
    this.errorMessage,
  });

  factory ProfileState.initial() {
    return const ProfileState(status: ProfileStatus.initial);
  }

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileEntity? userProfile,
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