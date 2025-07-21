import 'package:borrowlend/features/borrow/presentation/view/borrow_request_page.dart';
import 'package:borrowlend/features/borrow/presentation/view/ongoing_borrows_view.dart';
import 'package:borrowlend/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_event.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileViewModel({
    required GetProfileUseCase getProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        super(ProfileState.initial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<NavigateToProfilePage>(_onNavigateToProfilePage);
    on<NavigateToBorrowRequestsPage>(_onNavigateToBorrowRequestsPage);
    on<NavigateToOngoingBorrowPage>(_onNavigateToOngoingBorrowPage);
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
    // Update logic can be added later
  }

  Future<void> _onNavigateToProfilePage(
    NavigateToProfilePage event,
    Emitter<ProfileState> emit,
  ) async {
    await Navigator.push(
      event.context,
      MaterialPageRoute(builder: (context) => event.destination),
    );
  }

  Future<void> _onNavigateToBorrowRequestsPage(
    NavigateToBorrowRequestsPage event,
    Emitter<ProfileState> emit,
  ) async {
    await Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => BorrowRequestsPage(currentUserId: event.currentUserId),
      ),
    );
  }

  /// ✅ Navigate to Ongoing Borrow Page
  Future<void> _onNavigateToOngoingBorrowPage(
    NavigateToOngoingBorrowPage event,
    Emitter<ProfileState> emit,
  ) async {
    await Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => OngoingBorrowPage(currentUserId: event.currentUserId),
      ),
    );
  }
}
