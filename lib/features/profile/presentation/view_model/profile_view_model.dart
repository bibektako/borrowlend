import 'package:borrowlend/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:borrowlend/features/profile/domain/use_case/update_profile_usecase.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_event.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  // final UpdateProfileUseCase _updateProfileUseCase;

  ProfileViewModel({
    required GetProfileUseCase getProfileUseCase,
    // required UpdateProfileUseCase updateProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        // _updateProfileUseCase = updateProfileUseCase,
        super(ProfileState.initial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<NavigateToProfilePage>(_onNavigateToProfilePage);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    final result = await _getProfileUseCase();
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: () => failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: ProfileStatus.success,
        userProfile: profile,
      )),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.saving));
    
    // final result = await _updateProfileUseCase(event.profile);
    
    // result.fold(
    //   (failure) => emit(state.copyWith(
    //     status: ProfileStatus.failure,
    //     errorMessage: () => failure.message,
    //   )),
    //   // On success, emit a specific 'saveSuccess' status. The UI can
    //   // listen for this to show a confirmation and navigate back.
    //   (_) => emit(state.copyWith(
    //     status: ProfileStatus.saveSuccess,
    //     userProfile: event.profile, // Also update the profile in the state
    //   )),
    // );
  }

  /// Handles the [NavigateToProfilePage] event.
  Future<void> _onNavigateToProfilePage(
    NavigateToProfilePage event,
    Emitter<ProfileState> emit,
  ) async {
    // This logic is simple: just perform the navigation. No state change is needed.
    await Navigator.push(
      event.context,
      MaterialPageRoute(builder: (context) => event.destination),
    );
  }
}