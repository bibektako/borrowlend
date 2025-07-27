// features/auth/presentation/view_model/session/session_cubit.dart
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/auth_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SessionCubit extends HydratedCubit<SessionState> {
  // Start with an unauthenticated state. HydratedBloc will restore the last state if it exists.
  SessionCubit() : super(const SessionState.unauthenticated());

  // Called when a user successfully logs in.
  void showSession(UserEntity user) => emit(SessionState.authenticated(user));

  // Called when a user logs out.
  void clearSession() => emit(const SessionState.unauthenticated());

  // `fromJson` is called by HydratedBloc to restore the state.
  @override
  SessionState? fromJson(Map<String, dynamic> json) {
    try {
      // Assuming your UserEntity has a `fromJson` factory.
      final user = UserEntity.fromJson(json);
      return SessionState.authenticated(user);
    } catch (_) {
      return const SessionState.unauthenticated();
    }
  }

  // `toJson` is called by HydratedBloc to save the state.
  @override
  Map<String, dynamic>? toJson(SessionState state) {
    if (state.status == AuthStatus.authenticated && state.user != null) {
      // Assuming your UserEntity has a `toJson` method.
      return state.user!.toJson();
    }
    return null;
  }
}
