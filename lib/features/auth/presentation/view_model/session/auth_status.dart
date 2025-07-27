import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus { authenticated, unauthenticated }

class SessionState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;

  const SessionState._({this.status = AuthStatus.unauthenticated, this.user});

  const SessionState.authenticated(UserEntity user)
      : this._(status: AuthStatus.authenticated, user: user);

  const SessionState.unauthenticated() : this._();

  @override
  List<Object?> get props => [status, user];
}