import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_event.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final SessionCubit _sessionCubit;

  ProfileViewModel({
    required GetProfileUseCase getProfileUseCase,
    required SessionCubit sessionCubit,
  }) : _getProfileUseCase = getProfileUseCase,
       _sessionCubit = sessionCubit,
       super(ProfileState.initial()) {
    // Register all event handlers
    on<LoadUserProfile>(_onLoadUserProfile);
    on<NavigateToProfilePage>(_onNavigateToProfilePage);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getProfileUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: () => failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(status: ProfileStatus.success, userProfile: profile),
      ),
    );
  }

  // This handler is for navigating to pages within the profile section
  Future<void> _onNavigateToProfilePage(
    NavigateToProfilePage event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.context.mounted) {
      // Use push for navigating to sub-pages
      await Navigator.push(
        event.context,
        MaterialPageRoute(builder: (context) => event.destination),
      );
    }
  }

  /// Handles the entire logout process and emits the final state.
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // 1. Clear the persistent session state from HydratedBloc
    _sessionCubit.clearSession();

    // 2. Clear the token from shared preferences
    await serviceLocator<TokenSharedPrefs>().deleteToken();

    // 3. Clear the token from the ApiService instance

    // 4. Emit the success state to notify the UI. The BLoC's job is done.
    emit(
      state.copyWith(status: ProfileStatus.logoutSuccess, userProfile: null),
    );
  }
}
